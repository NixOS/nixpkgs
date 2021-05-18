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
  version = "4.2.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    rev = "v${version}";
    sha256 = "sha256-hbs+1x/pwv00dhm+1Yj1effddJZHDjs2K3oeBmdCY+k=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib~=3.1" "oauthlib" \
      --replace "requests~=2.24" "requests"
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
