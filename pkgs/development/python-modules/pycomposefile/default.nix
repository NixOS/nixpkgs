{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pycomposefile";
  version = "0.0.31";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SYul81giQLUM1FdgfabKJyrbSu4xdoaWblcE87ZbBwg=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyyaml ];

  # Tests are broken
  doCheck = false;

  pythonImportsCheck = [ "pycomposefile" ];

  meta = with lib; {
    description = "Python library for structured deserialization of Docker Compose files";
    homepage = "https://github.com/smurawski/pycomposefile";
    changelog = "https://github.com/smurawski/pycomposefile/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mdarocha ];
  };
}
