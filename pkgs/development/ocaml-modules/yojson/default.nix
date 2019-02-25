{ stdenv, fetchzip, ocaml, findlib, dune, cppo, easy-format, biniou }:
let
  pname = "yojson";
  param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then rec {
    version = "1.6.0";
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    sha256 = "1h73zkgqs6cl9y7p2l0cgjwyqa1fzcrnzv3k6w7wyq2p1q5m84xh";
    buildInputs = [ dune ];
    extra = { inherit (dune) installPhase; };
  } else rec {
    version = "1.2.3";
    url = "https://github.com/ocaml-community/yojson/archive/v${version}.tar.gz";
    sha256 = "10dvkndgwanvw4agbjln7kgb1n9s6lii7jw82kwxczl5rd1sgmvl";
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
    inherit (param) url sha256;
  };

  buildInputs = [ ocaml findlib ] ++ (param.buildInputs or []);

  propagatedBuildInputs = [ cppo easy-format biniou ];

  meta = with stdenv.lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "http://mjambon.com/${pname}.html";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
} // param.extra)
