{ lib
, stdenv
, aiohttp
, buildPythonPackage
, eventlet
, fetchFromGitHub
, iana-etc
, libredirect
, mock
, pytestCheckHook
, pythonOlder
, requests
, tornado
, websocket-client
}:

buildPythonPackage rec {
  pname = "python-engineio";
<<<<<<< HEAD
  version = "4.6.1";
=======
  version = "4.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-engineio";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-za2JY5Gu9MEqi3W1zxcuwYiJ5XLc43ig6Hdx/4JwDbY=";
=======
    hash = "sha256-sE6AlT01Rou427i9w+xwUTMflKxUr0Heqt2l+Y2AMmU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = [
    aiohttp
    eventlet
    mock
    requests
    tornado
    websocket-client
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = lib.optionalString stdenv.isLinux ''
    echo "nameserver 127.0.0.1" > resolv.conf
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols:/etc/resolv.conf=$(realpath resolv.conf) \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  # somehow effective log level does not change?
  disabledTests = [
    "test_logger"
  ];

  pythonImportsCheck = [
    "engineio"
  ];

  meta = with lib; {
    description = "Python based Engine.IO client and server";
    longDescription = ''
      Engine.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    changelog = "https://github.com/miguelgrinberg/python-engineio/blob/v${version}/CHANGES.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
