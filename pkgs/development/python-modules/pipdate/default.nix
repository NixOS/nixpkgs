{
  lib,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  packaging,
  requests,
  rich,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G2t+wsVGj7cDbsnWss7XqKU421WqygPzAZkhbTu9Jks=";
  };

  nativeBuildInputs = [ wheel ];

  propagatedBuildInputs = [
    appdirs
    packaging
    requests
    rich
    setuptools
  ];

  # Tests require network access and pythonImportsCheck requires configuration file
  doCheck = false;

  meta = {
    description = "Pip update helpers";
    mainProgram = "pipdate";
    homepage = "https://github.com/nschloe/pipdate";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
