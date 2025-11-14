{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2025.9.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xbojJ0xhxv70R7pqOTMyl9DCR/UwWdugvKQVysUR7cQ=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "regex" ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://github.com/mrabarnett/mrab-regex";
    license = [
      licenses.asl20
      licenses.cnri-python
    ];
    maintainers = with lib.maintainers; [ dwoffinden ];
  };
}
