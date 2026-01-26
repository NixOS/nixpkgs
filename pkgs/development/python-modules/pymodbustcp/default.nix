{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyModbusTCP";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sourceperl";
    repo = "pyModbusTCP";
    tag = "v${version}";
    hash = "sha256-troGTvGTzOTsbux7QQ6L6sHvjPIU9VRLHqFOBHEHUl0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyModbusTCP" ];

  meta = {
    description = "Simple Modbus/TCP client library for Python";
    homepage = "https://github.com/sourceperl/pyModbusTCP";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ blemouzy ];
  };
}
