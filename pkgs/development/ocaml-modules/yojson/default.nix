{ stdenv, fetchzip, ocaml, findlib, dune, cppo, easy-format, biniou }:
let
  pname = "yojson";
  param =
  if stdenv.lib.versionAtLeast ocaml.version "4.02" then rec {
    version = "1.7.0";
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    sha256 = "08llz96if8bcgnaishf18si76cv11zbkni0aldb54k3cn7ipiqvd";
    nativeBuildInputs = [ dune ];
    extra = { inherit (dune) installPhase; };
  } else rec {
    version = "1.2.3";
    url = "https://github.com/ocaml-community/yojson/archive/v${version}.tar.gz";
    sha256 = "10dvkndgwanvw4agbjln7kgb1n9s6lii7jw82kwxczl5rd1sgmvl";
    extra = {
      createFindlibDestdir = true;

      makeFlags = [ "PREFIX=$(out)" ];

      preBuild = "mkdir $out/bin";
    };
  };
in
stdenv.mkDerivation ({

  name = "ocaml${ocaml.version}-${pname}-${param.version}";

  src = fetchzip {
    inherit (param) url sha256;
  };

  nativeBuildInputs = [ ocaml findlib ] ++ (param.nativeBuildInputs or []);
  propagatedNativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ easy-format biniou ];
  configurePlatforms = [];

  meta = with stdenv.lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    platforms = ocaml.meta.platforms or [];
  };
} // param.extra)
