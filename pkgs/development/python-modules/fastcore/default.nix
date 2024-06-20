{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastcore";
  version = "1.5.46";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastcore";
    rev = "refs/tags/${version}";
    hash = "sha256-Jcnex5gDNTQqF0cL9FEdLx5vuNSsAicl0RvivC8QwSM=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fastcore" ];

  meta = with lib; {
    description = "Python module for Fast AI";
    homepage = "https://github.com/fastai/fastcore";
    changelog = "https://github.com/fastai/fastcore/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
