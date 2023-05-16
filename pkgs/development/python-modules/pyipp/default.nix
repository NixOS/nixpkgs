{ lib
, aiohttp
, aresponses
, awesomeversion
, backoff
, buildPythonPackage
, deepmerge
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, yarl
}:

buildPythonPackage rec {
  pname = "pyipp";
<<<<<<< HEAD
  version = "0.14.4";
=======
  version = "0.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
   owner = "ctalkington";
   repo = "python-ipp";
   rev = version;
<<<<<<< HEAD
   hash = "sha256-xE0fdT+Ffdf4iOHWZzRa7YWtHt92lFdA/sbwjblMR40=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace "--cov" ""
  '';

=======
   hash = "sha256-xTSi5Eh6vVuQ+Kr/oVMlh5YcckVRsfTUgdmGHndmX+Q=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    awesomeversion
    backoff
    deepmerge
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;
=======
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"' \
      --replace " --cov" ""
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "pyipp"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/ctalkington/python-ipp/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Asynchronous Python client for Internet Printing Protocol (IPP)";
    homepage = "https://github.com/ctalkington/python-ipp";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
