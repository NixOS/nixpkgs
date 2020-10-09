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
  version = "4.1.0";
  disabled = pythonOlder "3.5"; # uses type hints

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "netatmo-api-python";
    rev = "v${version}";
    sha256 = "0x3xq6ni9rl5k3vi0ydqafdzvza785ycnlgyikgqbkppbh3j33ig";
  };

  propagatedBuildInputs = [ oauthlib requests requests_oauthlib ];

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
