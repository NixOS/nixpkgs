{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, python
, py-multiaddr
, requests
, pytestCheckHook
, pytest-cov
, pytest-dependency
, pytest-localserver
, pytest-mock
, pytest-order
, pytest-cid
, mock
, ipfs
, httpx
, httpcore
}:

buildPythonPackage rec {
  pname = "ipfshttpclient";
  version = "0.8.0a2";
  format = "flit";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ipfs-shipyard";
    repo = "py-ipfs-http-client";
    rev = version;
    sha256 = "sha256-OmC67pN2BbuGwM43xNDKlsLhwVeUbpvfOazyIDvoMEA=";
  };

  propagatedBuildInputs = [
    py-multiaddr
    requests
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-dependency
    pytest-localserver
    pytest-mock
    pytest-order
    pytest-cid
    mock
    ipfs
    httpcore
    httpx
  ];

  postPatch = ''
    # This can be removed for the 0.8.0 release
    # Use pytest-order instead of pytest-ordering since the latter is unmaintained and broken
    substituteInPlace test/run-tests.py \
      --replace 'pytest_ordering' 'pytest_order'
    substituteInPlace test/functional/test_miscellaneous.py \
      --replace '@pytest.mark.last' '@pytest.mark.order("last")'
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -X utf8 test/run-tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "ipfshttpclient" ];

  meta = with lib; {
    description = "A python client library for the IPFS API";
    homepage = "https://github.com/ipfs-shipyard/py-ipfs-http-client";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner Luflosi ];
  };
}
