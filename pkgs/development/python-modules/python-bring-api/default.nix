{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage {
  pname = "python-bring-api";
  version = "3.0.0-unstable-2024-02-03";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eliasball";
    repo = "python-bring-api";
    # https://github.com/eliasball/python-bring-api/issues/16
    rev = "8043562b22be1f6421a8771774868b105b6ca375";
    hash = "sha256-VCGCm9N6pMhEYT9WuWh7qKacZEf6bcIpEsILfCC6his=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "python_bring_api" ];

  meta = with lib; {
    description = "Module to access the Bring! shopping lists API";
    homepage = "https://github.com/eliasball/python-bring-api";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
