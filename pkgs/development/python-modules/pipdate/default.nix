{
  lib,
  appdirs,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  packaging,
  pythonOlder,
  requests,
  rich,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pipdate";
  version = "0.5.6";
  format = "pyproject";
  disabled = pythonOlder "3.6";

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
  ]
  ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Tests require network access and pythonImportsCheck requires configuration file
  doCheck = false;

  meta = with lib; {
    description = "Pip update helpers";
    mainProgram = "pipdate";
    homepage = "https://github.com/nschloe/pipdate";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
