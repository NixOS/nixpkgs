{ buildDunePackage
, lib
, fetchFromGitHub
, ocaml
, ppx_deriving
, ppx_deriving_yojson
, easy_logging
}:

buildDunePackage rec {
  pname = "easy_logging_yojson";
  inherit (easy_logging) version src;

  nativeBuildInputs = [
    ocaml
  ];

  propagatedBuildInputs = [
    ppx_deriving
    ppx_deriving_yojson
    easy_logging
  ];

  useDune2 = true;
  strictDeps = true;

  meta = with lib; {
    description = "Configuration loader for easy_logging with yojson backend";
    homepage = "https://sapristi.github.io/easy_logging/";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = ocaml.meta.platforms or [];
  };
}
