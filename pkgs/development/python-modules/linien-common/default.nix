{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-metadata,
  numpy,
  rpyc4,
  scipy,
  appdirs,
  callPackage,
}:

buildPythonPackage rec {
  pname = "linien-common";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linien-org";
    repo = "linien";
    rev = "refs/tags/v${version}";
    hash = "sha256-V6oo0a4cNlvn4pIwzchvCTOu7qtUGS+Pc0qpbEsvGZo=";
  };

  sourceRoot = "${src.name}/linien-common";

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    importlib-metadata
    numpy
    rpyc4
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      fsagbuya
      doronbehar
    ];
  };
}
