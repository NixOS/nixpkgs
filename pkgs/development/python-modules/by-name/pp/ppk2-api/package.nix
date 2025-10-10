{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyserial,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ppk2-api";
  version = "0.9.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "IRNAS";
    repo = "ppk2-api-python";
    tag = "v${version}";
    hash = "sha256-fubDFtOXiv2YFYUCOUbuyXs1sHgs0/6ZVK9sAwxQ+Pk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ppk2_api" ];

  meta = with lib; {
    description = "Power Profiling Kit 2 unofficial Python API";
    homepage = "https://github.com/IRNAS/ppk2-api-python";
    changelog = "https://github.com/IRNAS/ppk2-api-python/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
  };
}
