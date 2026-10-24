{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  toml,
}:

buildPythonPackage rec {
  pname = "confight";
  version = "2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iodoexnh9tG4dgkjDXCUzWRFDhRlJ3HRgaNhxG2lwPY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ toml ];

  pythonImportsCheck = [ "confight" ];

  doCheck = false;

  meta = {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/avature/confight";
    changelog = "https://github.com/Avature/confight/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "confight";
  };
}
