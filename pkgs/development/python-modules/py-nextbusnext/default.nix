{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "2.0.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-mmuD5edgcesMFsdfbWJyzOuKLCgsqvUPG61j/dA6Crc=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "py_nextbus" ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
