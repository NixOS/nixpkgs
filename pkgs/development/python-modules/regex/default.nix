{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2025.7.34";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nq2XZSF6/QSoaCLfzU7SdH3+Qm6IfaQTsV/wrCRX4ho=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "regex" ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
