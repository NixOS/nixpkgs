{ stdenv, fetchzip, ocaml, findlib, dune, cppo, easy-format, biniou }:
let
  pname = "yojson";
  param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then {
    version = "1.4.1";
    sha256 = "0nwsfkmqpyfab4rxq76q8ff7giyanghw08094jyrp275v99zdjr9";
    buildInputs = [ dune ];
    extra = { inherit (dune) installPhase; };
  } else {
    version = "1.2.3";
    sha256 = "10dvkndgwanvw4agbjln7kgb1n9s6lii7jw82kwxczl5rd1sgmvl";
    buildInputs = [];
    extra = {
      createFindlibDestdir = true;

      makeFlags = "PREFIX=$(out)";

      preBuild = "mkdir $out/bin";
    };
  };
in
stdenv.mkDerivation ({

  name = "ocaml${ocaml.version}-${pname}-${param.version}";

  src = fetchzip {
    url = "https://github.com/mjambon/${pname}/archive/v${param.version}.tar.gz";
    inherit (param) sha256;
  };

  buildInputs = [ ocaml findlib ] ++ param.buildInputs;

  propagatedBuildInputs = [ cppo easy-format biniou ];

  meta = with stdenv.lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "http://mjambon.com/${pname}.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
} // param.extra)
