{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-oauthlib
, requests-mock
, setuptools-scm
, time-machine
}:

buildPythonPackage rec {
  pname = "pyatmo";
  version = "7.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jabesq";
    repo = "pyatmo";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-WrpRLAfViudC0n7AG5es2CM8XbZ0yJqXCY9yod9czb0=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    oauthlib
    requests
    requests-oauthlib
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    requests-mock
    time-machine
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "oauthlib~=3.1" "oauthlib" \
      --replace "requests~=2.24" "requests"
  '';

  pythonImportsCheck = [
    "pyatmo"
  ];

  meta = with lib; {
    description = "Simple API to access Netatmo weather station data";
    homepage = "https://github.com/jabesq/pyatmo";
    license = licenses.mit;
    maintainers = with maintainers; [ delroth ];
  };
}
