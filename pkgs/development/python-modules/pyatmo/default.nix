{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, freezegun
, oauthlib
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests_oauthlib
, requests-mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "6.1.0";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    rev = "v${version}";
    sha256 = "sha256-Iscnv3hfYa8QFiXMUN334Muo0oGqnnK11RPNxQJggG0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    oauthlib
    requests
    requests_oauthlib
  ];

  checkInputs = [
    freezegun
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib~=3.1" "oauthlib" \
      --replace "requests~=2.24" "requests"
  '';

  pythonImportsCheck = [ "pyatmo" ];

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    homepage = "https://github.com/jabesq/pyatmo";
    license = licenses.mit;
    maintainers = with maintainers; [ delroth ];
  };
}
