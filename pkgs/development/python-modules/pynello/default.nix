{ lib
, buildPythonPackage
, fetchFromGitHub
, python-dateutil
, pythonOlder
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "pynello";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = pname;
    rev = version;
    sha256 = "015rlccsn2vff9if82rjj2fza3bjbmawqhamc22wq40gq7pbfk5i";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    requests_oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynello" ];

  meta = with lib; {
    description = "Python library for nello.io intercoms";
    homepage = "https://github.com/pschmitt/pynello";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
