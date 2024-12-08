{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mapado";
    repo = "haversine";
    rev = "refs/tags/v${version}";
    hash = "sha256-KqcDDQdAOnrmiq+kf8rLHy85rNnhatZTOzCCU91lOrU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "haversine" ];

  meta = with lib; {
    description = "Python module the distance between 2 points on earth";
    homepage = "https://github.com/mapado/haversine";
    changelog = "https://github.com/mapado/haversine/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
