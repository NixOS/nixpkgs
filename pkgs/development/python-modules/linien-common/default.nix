{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  numpy,
  rpyc,
  scipy,
  appdirs,
  callPackage,
}:

buildPythonPackage rec {
  pname = "linien-common";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "linien";
    rev = "refs/tags/v${version}";
    hash = "sha256-j6oiP/usLfV5HZtKLcXQ5pHhhxRG05kP2FMwingiWm0=";
  };

  sourceRoot = "${src.name}/linien-common";

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "importlib-metadata" ];

  dependencies = [
    importlib-metadata
    numpy
    rpyc
    scipy
    appdirs
  ];

  pythonImportsCheck = [ "linien_common" ];

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Shared components of the Linien spectroscopy lock application";
    homepage = "https://github.com/linien-org/linien/tree/develop/linien-common";
    changelog = "https://github.com/linien-org/linien/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      fsagbuya
      doronbehar
    ];
  };
}
