{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.8.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    tag = version;
    hash = "sha256-m/22tTIysVFgNWUUWKC/1TV/dkEki8dDACb0XvKayAw=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    changelog = "https://github.com/fastai/fastcore/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
