{stdenv, fetchurl, ocaml, findlib, cppo, easy-format, biniou}:
let
  pname = "yojson";
  version = "1.1.8";
  webpage = "http://mjambon.com/${pname}.html";
in
stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchurl {
    url = "http://mjambon.com/releases/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ayx17dimnpavdfyq6dk9xv2x1fx69by85vc6vl3nqxjkcv5d2rv";
  };

  buildInputs = [ ocaml findlib ];

  propagatedBuildInputs = [ cppo easy-format biniou ];

  createFindlibDestdir = true;

  makeFlags = "PREFIX=$(out)";

  preBuild = ''
    mkdir $out/bin
  '';

  meta = with stdenv.lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "${webpage}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms;
  };
}
