{ buildDunePackage
, lib
, fetchFromGitHub
, ocaml
, calendar
}:

buildDunePackage rec {
  pname = "easy_logging";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "sapristi";
    repo = "easy_logging";
    rev = "v${version}";
    sha256 = "Xy6Rfef7r2K8DTok7AYa/9m3ZEV07LlUeMQSRayLBco=";
  };

  nativeBuildInputs = [
    ocaml
  ];

  propagatedBuildInputs = [
    calendar
  ];

  useDune2 = true;
  strictDeps = true;

  meta = with lib; {
    description = "Module to log messages";
    homepage = "https://sapristi.github.io/easy_logging/";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = ocaml.meta.platforms or [];
  };
}
