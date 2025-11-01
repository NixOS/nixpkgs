{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = version;
    hash = "sha256-75HeMXzOYECh09ah+mvazQeEQOgcFuy8Cw9AYgu6Sz8=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = with lib; {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    changelog = "https://github.com/fastai/fastcore/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
