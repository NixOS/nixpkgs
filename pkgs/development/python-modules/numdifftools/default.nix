{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  pdm-backend,
}:

buildPythonPackage rec {
  pname = "numdifftools";
  version = "0.9.42";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pbrod";
    repo = "numdifftools";
    tag = "v${version}";
    hash = "sha256-tNPv+KJuSmMHItHfRUjMIFtAFB+vC530sp+Am0VRG44=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    numpy
    scipy
  ];

  # Tests requires algopy and other modules which are optional and/or not available
  doCheck = false;

  pythonImportsCheck = [ "numdifftools" ];

  meta = {
    description = "Library to solve automatic numerical differentiation problems in one or more variables";
    homepage = "https://github.com/pbrod/numdifftools";
    changelog = "https://github.com/pbrod/numdifftools/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
