{ lib
, buildPythonPackage
, fetchPypi
, pubnub
, pycryptodomex
, requests
}:

buildPythonPackage rec {
  pname = "pubnubsub-handler";
  version = "1.0.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:1c44x19zi709sazgl060nkqa7vbaf3iyhwcnwdykhsbipvp6bscy";
  };

  propagatedBuildInputs = [
    pubnub
    pycryptodomex
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pubnubsubhandler" ];

  meta = with lib; {
    description = "PubNub subscription between PubNub and Home Assistant";
    homepage = "https://github.com/w1ll1am23/pubnubsub-handler";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
