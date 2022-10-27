{ lib
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, mock
, pytest-asyncio
, pytest-timeout
, pytest-vcr
, pytestCheckHook
, pythonOlder
, requests
, requests-mock
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "rxv";
  version = "0.7.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "wuub";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jldnlzbfg5jm1nbgv91mlvcqkswd9f2n3qj9aqlbmj1cxq19yz8";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    defusedxml
    requests
  ];

  checkInputs = [
    mock
    pytest-asyncio
    pytest-timeout
    pytest-vcr
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "rxv" ];

  meta = with lib; {
    description = "Python library for communicate with Yamaha RX-Vxxx receivers";
    homepage = "https://github.com/wuub/rxv";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
