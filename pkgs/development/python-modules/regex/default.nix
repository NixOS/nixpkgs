{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2024.5.15";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0+4C2eX0gsyDCRNKke6qy90iYboRGw/vN0jutJE+aiw=";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [ "regex" ];

  meta = with lib; {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
    license = licenses.psfl;
    maintainers = with maintainers; [ abbradar ];
  };
}
