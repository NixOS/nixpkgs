{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lcgit";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "lcgit";
    tag = "v${version}";
    hash = "sha256-unw5xY5iZlVrV01hchHS3Ar+zpF7awTAutcqndKH0Ic=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "lcgit" ];

  meta = with lib; {
    description = "Pythonic Linear Congruential Generator iterator";
    homepage = "https://github.com/cisagov/lcgit";
    changelog = "https://github.com/cisagov/lcgit/releases/tag/${src.tag}";
    license = licenses.cc0;
    maintainers = with maintainers; [ fab ];
  };
}
