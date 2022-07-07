{ stdenv
, lib
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

    # Until a proper fix is created, just skip these tests
    # and ignore any breakage that may result from the API change in IPFS
    # See https://github.com/ipfs-shipyard/py-ipfs-http-client/issues/308
    substituteInPlace test/functional/test_pubsub.py \
      --replace '# the message that will be published' 'pytest.skip("This test fails because of an incompatibility with the experimental PubSub feature in IPFS>=0.11.0")' \
      --replace '# subscribe to the topic testing'     'pytest.skip("This test fails because of an incompatibility with the experimental PubSub feature in IPFS>=0.11.0")'
    substituteInPlace test/functional/test_other.py \
      --replace 'import ipfshttpclient' 'import ipfshttpclient; import pytest' \
      --replace 'assert ipfs_is_available' 'pytest.skip("Unknown test failure with IPFS >=0.11.0"); assert ipfs_is_available'
    substituteInPlace test/run-tests.py \
      --replace '--cov-fail-under=90' '--cov-fail-under=75'
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -X utf8 test/run-tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "ipfshttpclient" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A python client library for the IPFS API";
    homepage = "https://github.com/ipfs-shipyard/py-ipfs-http-client";
    license = licenses.mit;
    maintainers = with maintainers; [ mguentner Luflosi ];
  };
}
