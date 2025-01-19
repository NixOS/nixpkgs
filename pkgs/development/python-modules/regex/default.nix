{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "regex";
  version = "2024.9.11";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bBiMMH6EM7y2PcGRUCLetVO0IDpwci/FQsNjvxIKAf0=";
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
