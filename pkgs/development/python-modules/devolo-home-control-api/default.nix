{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, websocket-client
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-home-control-api";
  version = "0.17.4";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_home_control_api";
    rev = "v${version}";
    sha256 = "sha256-N/48Q2IEL194vCzrPPuy+mRNejXfkoXy2t2oe0Y6ug4=";
  };

  propagatedBuildInputs = [
    requests
    zeroconf
    websocket-client
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  postPatch = ''
    # setup.py is not able to detect the version with setuptools_scm
    substituteInPlace setup.py \
      --replace "setuptools_scm" "" \
      --replace 'use_scm_version=True' 'use_scm_version="${version}"'
  '';

  # Disable test that requires network access
  disabledTests = [
    "test__on_pong"
    "TestMprm"
  ];

  pythonImportsCheck = [ "devolo_home_control_api" ];

  meta = with lib; {
    description = "Python library to work with devolo Home Control";
    homepage = "https://github.com/2Fake/devolo_home_control_api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
