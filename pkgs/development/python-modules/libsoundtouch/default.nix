{ lib
, buildPythonPackage
, fetchFromGitHub
, enum-compat
, requests
, websocket_client
, zeroconf
, pytestCheckHook
}:

buildPythonPackage rec {
  pname   = "libsoundtouch";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "CharlesBlonde";
    repo = "libsoundtouch";
    rev = version;
    sha256 = "1wl2w5xfdkrv0qzsz084z2k6sycfyq62mqqgciycha3dywf2fvva";
  };

  propagatedBuildInputs = [
    requests
    enum-compat
    websocket_client
    zeroconf
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # mock data order mismatch
    "test_select_content_item"
    "test_snapshot_restore"
  ];

  meta = with lib; {
    description = "Bose Soundtouch Python library";
    homepage    = "https://github.com/CharlesBlonde/libsoundtouch";
    license     = licenses.asl20;
  };
}
