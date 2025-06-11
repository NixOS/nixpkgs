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
  version = "0.0.32";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o1XVFcTE/5LuWhZZDeizZ6O+SCcEZZLQhw+MtqxKbjQ=";
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
