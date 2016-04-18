{stdenv, fetchurl, ocaml, findlib, ounit, expat}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "0.9.1";
  pname = "ocaml-expat";
  testcase = fetchurl {
    url = "http://www.w3.org/TR/1998/REC-xml-19980210.xml";
    sha256 = "00a3gsfvlkdhmcbziqhvpvy1zmcgbcihfqwcvl6ay03zf7gvw0k1";
  };

in

stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://www.xs4all.nl/~mmzeeman/ocaml/${pname}-${version}.tar.gz";
    sha256 = "16n2j3y0jc9xgqyshw9plrwqnjiz30vnpbhahmgxlidbycw8rgjz";
  };

  buildInputs = [ocaml findlib ounit expat];

  createFindlibDestdir = true;

  patches = [ ./unittest.patch ];

  postPatch = ''
    substituteInPlace "unittest.ml" \
      --replace "/home/maas/xml-samples/REC-xml-19980210.xml.txt" "${testcase}"
    substituteInPlace Makefile --replace "EXPAT_LIBDIR=/usr/local/lib" "EXPAT_LIBDIR=${expat.out}/lib" \
    substituteInPlace Makefile --replace "EXPAT_INCDIR=/usr/local/include" "EXPAT_INCDIR=${expat.dev}/include" \
  '';

  configurePhase = "true";  	# Skip configure

  buildPhase = ''
    make all allopt
  '';

  doCheck = true;

  checkTarget = "testall";

  meta = {
    homepage = http://www.xs4all.nl/~mmzeeman/ocaml/;
    description = "An ocaml wrapper for the Expat XML parsing library";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
  };
}
