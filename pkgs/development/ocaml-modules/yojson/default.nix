{ stdenv, fetchzip, ocaml, findlib, cppo, easy-format, biniou }:
let
  pname = "yojson";
  param =
  if stdenv.lib.versionAtLeast ocaml.version "4.01" then {
    version = "1.3.3";
    sha256 = "02l11facbr6bxrxq95vrcp1dxapp02kv7g4gq8rm62pb3dj5c6g7";
  } else {
    version = "1.2.3";
    sha256 = "10dvkndgwanvw4agbjln7kgb1n9s6lii7jw82kwxczl5rd1sgmvl";
  };
in
stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${param.version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${param.version}.tar.gz";
    inherit (param) sha256;
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
