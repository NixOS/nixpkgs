{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "haversine";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapado";
    repo = "haversine";
    tag = "v${version}";
    hash = "sha256-KqcDDQdAOnrmiq+kf8rLHy85rNnhatZTOzCCU91lOrU=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "haversine" ];

  meta = {
    description = "Python module the distance between 2 points on earth";
    homepage = "https://github.com/mapado/haversine";
    changelog = "https://github.com/mapado/haversine/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
