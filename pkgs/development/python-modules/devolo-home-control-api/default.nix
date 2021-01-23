{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-cov
, pytest-mock
, requests
, zeroconf
, websocket_client
, pytest-runner
}:

buildPythonPackage rec {
  pname = "devolo-home-control-api";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_home_control_api";
    rev = "v${version}";
    sha256 = "19zzdbx0dxlm8pq0yk00nn9gqqblgpp16fgl7z6a98hsa6459zzb";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [
    requests
    zeroconf
    websocket_client
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-mock
  ];

  # Disable test that requires network access
  disabledTests = [ "test__on_pong" ];
  pythonImportsCheck = [ "devolo_home_control_api" ];

  meta = with lib; {
    description = "Python library to work with devolo Home Control";
    homepage = "https://github.com/2Fake/devolo_home_control_api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
