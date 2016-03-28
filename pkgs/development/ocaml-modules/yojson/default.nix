{ stdenv, fetchzip, ocaml, findlib, cppo, easy-format, biniou }:
let
  pname = "yojson";
  version = "1.2.3";
in
stdenv.mkDerivation {

  name = "ocaml-${pname}-${version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${version}.tar.gz";
    sha256 = "10dvkndgwanvw4agbjln7kgb1n9s6lii7jw82kwxczl5rd1sgmvl";
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
    homepage = "http://mjambon.com/${pname}.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
}
