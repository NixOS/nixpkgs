{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, httpx
, protobuf
, pytest-asyncio
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, segno
, setuptools-scm
, syrupy
=======
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, zeroconf
}:

buildPythonPackage rec {
  pname = "devolo-plc-api";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "2Fake";
    repo = "devolo_plc_api";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-roKwCNOvSVRFKBxXz0a9SDo925RHqX0qKv/1QWD3diw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "protobuf>=4.22.0" "protobuf"
  '';

=======
    hash = "sha256-ika0mypHo7a8GCa2eNhOLIhMZ2ASwJOxV4mmAzvJm0E=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    httpx
    protobuf
<<<<<<< HEAD
    segno
    zeroconf
  ];

  __darwinAllowLocalNetworking = true;

=======
    zeroconf
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
<<<<<<< HEAD
    syrupy
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonImportsCheck = [
    "devolo_plc_api"
  ];

  meta = with lib; {
    description = "Module to interact with Devolo PLC devices";
    homepage = "https://github.com/2Fake/devolo_plc_api";
    changelog = "https://github.com/2Fake/devolo_plc_api/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
