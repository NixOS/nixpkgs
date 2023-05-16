{ lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, aiofiles
, aiosqlite
, buildPythonPackage
, cryptography
, fetchFromGitHub
<<<<<<< HEAD
, pyopenssl
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, sortedcontainers
, typing-extensions
}:

buildPythonPackage rec {
  pname = "asyncua";
<<<<<<< HEAD
  version = "1.0.4";
=======
  version = "1.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "FreeOpcUa";
    repo = "opcua-asyncio";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-gAyvo+VJPdS/UpXN/h8LqbIRyx84fifSUsW2GUzLgfo=";
=======
    hash = "sha256-DnBxR4nD3dBBhiElDuRgljHaoBPiakdjY/VFn3VsKEQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };

  postPatch = ''
    # https://github.com/FreeOpcUa/opcua-asyncio/issues/1263
    substituteInPlace setup.py \
      --replace ", 'asynctest'" ""

    # Workaround hardcoded paths in test
    # "test_cli_tools_which_require_sigint"
    substituteInPlace tests/test_tools.py \
      --replace "tools/" "$out/bin/"
  '';

  propagatedBuildInputs = [
<<<<<<< HEAD
    aiofiles
    aiosqlite
    cryptography
    pyopenssl
    python-dateutil
    pytz
    sortedcontainers
=======
    aiosqlite
    aiofiles
    pytz
    python-dateutil
    sortedcontainers
    cryptography
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pythonImportsCheck = [
    "asyncua"
  ];

<<<<<<< HEAD
  disabledTests = lib.optionals stdenv.isDarwin [
    # Failed: DID NOT RAISE <class 'asyncio.exceptions.TimeoutError'>
    "test_publish"
    # OSError: [Errno 48] error while attempting to bind on address ('127.0.0.1',...
    "test_anonymous_rejection"
    "test_certificate_handling_success"
    "test_encrypted_private_key_handling_success"
    "test_encrypted_private_key_handling_success_with_cert_props"
    "test_encrypted_private_key_handling_failure"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "OPC UA / IEC 62541 Client and Server for Python";
    homepage = "https://github.com/FreeOpcUa/opcua-asyncio";
    changelog = "https://github.com/FreeOpcUa/opcua-asyncio/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ harvidsen ];
  };
}
