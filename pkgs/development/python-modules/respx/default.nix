{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, flask
, httpcore
, httpx
, pytest-asyncio
, pytestCheckHook
, pythonOlder
=======
, httpcore
, httpx
, flask
, pytest-asyncio
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, starlette
, trio
}:

buildPythonPackage rec {
  pname = "respx";
<<<<<<< HEAD
  version = "0.20.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "0.20.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lundberg";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-OiBKNK8V9WNQDe29Q5+E/jjBWD0qFcYUzhYUWA+7oFc=";
=======
    hash = "sha256-Qs3+NWMKiAFlKTTosdyHOxWRPKFlYQD20+MKiKR371U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    httpx
  ];

  nativeCheckInputs = [
    httpcore
    httpx
    flask
    pytest-asyncio
    pytestCheckHook
    starlette
    trio
  ];

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  disabledTests = [
    "test_pass_through"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "respx"
  ];
=======
  pythonImportsCheck = [ "respx" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Python library for mocking HTTPX";
    homepage = "https://lundberg.github.io/respx/";
<<<<<<< HEAD
    changelog = "https://github.com/lundberg/respx/blob/${version}/CHANGELOG.md";
=======
    changelog = "https://github.com/lundberg/respx/blob/${src.rev}/CHANGELOG.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
