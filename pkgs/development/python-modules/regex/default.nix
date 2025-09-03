{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2025.7.34";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nq2XZSF6/QSoaCLfzU7SdH3+Qm6IfaQTsV/wrCRX4ho=";
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
    maintainers = [ ];
  };
}
