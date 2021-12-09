{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "defusedxml";
  version = "0.7.1";

  src = fetchFromGitHub {
     owner = "tiran";
     repo = "defusedxml";
     rev = "v0.7.1";
     sha256 = "0x2mmqf8g67bbvl66sxg1jnd0pyz1pc694nk554ipj4wkcd0w6ng";
  };

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  pythonImportsCheck = [ "defusedxml" ];

  meta = with lib; {
    description = "Python module to defuse XML issues";
    homepage = "https://github.com/tiran/defusedxml";
    license = licenses.psfl;
    maintainers = with maintainers; [ fab ];
  };
}
