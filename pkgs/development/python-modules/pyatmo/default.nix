{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, oauthlib
, requests
, requests_oauthlib
, freezegun
, pytestCheckHook
, requests-mock
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "4.2.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "netatmo-api-python";
    rev = "v${version}";
    sha256 = "12lmjhqjn71a358nkpzl3dwgiwmmz4lcv9f0qf69ngznpiirk28m";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib~=3.1.0" "oauthlib" \
      --replace "requests~=2.23.0" "requests"
  '';

  propagatedBuildInputs = [
    oauthlib
    requests
    requests_oauthlib
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "pyatmo" ];

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    license = licenses.mit;
    homepage = "https://github.com/jabesq/netatmo-api-python";
    maintainers = with maintainers; [ delroth ];
  };
}
