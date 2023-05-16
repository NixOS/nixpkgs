{ lib
<<<<<<< HEAD
, anyio
, async-timeout
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, kasa-crypt
, orjson
, poetry-core
, pydantic
=======
, asyncclick
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, pydantic
, poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, voluptuous
}:

buildPythonPackage rec {
  pname = "python-kasa";
<<<<<<< HEAD
  version = "0.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";
=======
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-7GJnkT7FOYzytQyOCP8zU5hUk4SbeC7gc1qkhl5eXGo=";
=======
    hash = "sha256-vp2r842f9A2lEFLhUcHyGZavAWT4Ke9mH+FAlGucdqo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
<<<<<<< HEAD
    anyio
    async-timeout
    asyncclick
=======
    asyncclick
    importlib-metadata
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    voluptuous
  ];

<<<<<<< HEAD
  passthru.optional-dependencies = {
    speedup = [
      kasa-crypt
      orjson
    ];
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  disabledTestPaths = [
    # Skip the examples tests
    "kasa/tests/test_readme_examples.py"
  ];

  pythonImportsCheck = [
    "kasa"
  ];

  meta = with lib; {
    description = "Python API for TP-Link Kasa Smarthome products";
    homepage = "https://python-kasa.readthedocs.io/";
    changelog = "https://github.com/python-kasa/python-kasa/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
