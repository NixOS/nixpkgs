{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, semver
, deepmerge
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blebox-uniapi";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "blebox";
    repo = "blebox_uniapi";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cLSI6wa3gHE0QkSVVWMNpb5fyQy0TLDNSqOuGlDJGJc=";
=======
    hash = "sha256-hr3HD8UiI+bKiHcXGnyomJMzP+/GVXLgSUxeH2U6l/4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    aiohttp
    semver
  ];

  nativeCheckInputs = [
    deepmerge
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "blebox_uniapi"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://github.com/blebox/blebox_uniapi/blob/v${version}/HISTORY.rst";
=======
    changelog = "https://github.com/blebox/blebox_uniapi/blob/${version}/HISTORY.rst";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Python API for accessing BleBox smart home devices";
    homepage = "https://github.com/blebox/blebox_uniapi";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
