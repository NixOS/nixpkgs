{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "minidump";
  version = "0.0.23";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R+tza5C/2egkajScmilp/8qowoSklYVfEB+f0KMNBqQ=";
  };

  nativeBuildInputs = [ setuptools ];

  # Upstream doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "minidump" ];

  meta = with lib; {
    description = "Python library to parse and read Microsoft minidump file format";
    mainProgram = "minidump";
    homepage = "https://github.com/skelsec/minidump";
    changelog = "https://github.com/skelsec/minidump/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
