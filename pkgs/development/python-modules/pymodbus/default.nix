{ lib
, aiohttp
, buildPythonPackage
, click
, fetchFromGitHub
, mock
, prompt-toolkit
, pygments
, pyserial
<<<<<<< HEAD
, pytest-asyncio
=======
, pyserial-asyncio
, pytest-asyncio
, pytest-rerunfailures
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-xdist
, pytestCheckHook
, redis
, sqlalchemy
<<<<<<< HEAD
, twisted
, typer
=======
, tornado
, twisted
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pymodbus";
<<<<<<< HEAD
  version = "3.5.2";
=======
  version = "3.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pymodbus-dev";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-FOmR9yqLagqcsAVxqHxziEcnZ5M9QpL2qIp8x2gS2PU=";
  };

  passthru.optional-dependencies = {
    repl = [
      aiohttp
      typer
      prompt-toolkit
      pygments
      click
    ] ++ typer.optional-dependencies.all;
    serial = [
      pyserial
    ];
  };
=======
    hash = "sha256-GHyDlt046v4KP9KQRnXH6F+3ikoCjbhVHEQuSdm99a8=";
  };

  # Twisted asynchronous version is not supported due to a missing dependency
  propagatedBuildInputs = [
    aiohttp
    click
    prompt-toolkit
    pygments
    pyserial
    pyserial-asyncio
    tornado
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [
    mock
    pytest-asyncio
<<<<<<< HEAD
=======
    pytest-rerunfailures
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-xdist
    pytestCheckHook
    redis
    sqlalchemy
    twisted
<<<<<<< HEAD
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    pushd test
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "pymodbus"
  ];

  disabledTests = [
    # Tests often hang
    "test_connected"
  ];

=======
  ];

  pytestFlagsArray = [
    "--reruns" "3" # Racy socket tests
  ];

  pythonImportsCheck = [ "pymodbus" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python implementation of the Modbus protocol";
    longDescription = ''
      Pymodbus is a full Modbus protocol implementation using twisted,
      torndo or asyncio for its asynchronous communications core. It can
      also be used without any third party dependencies if a more
      lightweight project is needed.
    '';
    homepage = "https://github.com/pymodbus-dev/pymodbus";
    changelog = "https://github.com/pymodbus-dev/pymodbus/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
