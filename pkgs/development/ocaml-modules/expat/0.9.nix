{stdenv, lib, fetchurl, ocaml, findlib, ounit, expat}:

let
  pname = "ocaml-expat";
  testcase = fetchurl {
    url = "http://www.w3.org/TR/1998/REC-xml-19980210.xml";
    sha256 = "00a3gsfvlkdhmcbziqhvpvy1zmcgbcihfqwcvl6ay03zf7gvw0k1";
  };

in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "0.9.1";

  src = fetchurl {
    url = "http://www.xs4all.nl/~mmzeeman/ocaml/${pname}-${version}.tar.gz";
    sha256 = "16n2j3y0jc9xgqyshw9plrwqnjiz30vnpbhahmgxlidbycw8rgjz";
  };

  nativeBuildInputs = [ocaml findlib ];
  buildInputs = [ ounit expat];

  strictDeps = true;

  createFindlibDestdir = true;

  patches = [ ./unittest.patch ];

  postPatch = ''
    substituteInPlace "unittest.ml" \
      --replace "/home/maas/xml-samples/REC-xml-19980210.xml.txt" "${testcase}"
    substituteInPlace Makefile --replace "EXPAT_LIBDIR=/usr/local/lib" "EXPAT_LIBDIR=${expat.out}/lib" \
      --replace "EXPAT_INCDIR=/usr/local/include" "EXPAT_INCDIR=${expat.dev}/include" \
      --replace "gcc" "\$(CC)"
  '';

  dontConfigure = true;  	# Skip configure

  buildPhase = ''
    make all allopt
  '';

  doCheck = true;

  checkTarget = "testall";

  meta = {
    homepage = "http://www.xs4all.nl/~mmzeeman/ocaml/";
    description = "An ocaml wrapper for the Expat XML parsing library";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.roconnor ];
  };
}
