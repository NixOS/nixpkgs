{ lib
, aiohttp
, platformdirs
, buildPythonPackage
, docutils
, fetchFromGitHub
, flaky
, installShellFiles
, packaging
, pycurl
, pytest-asyncio
, pytest-httpbin
, pytestCheckHook
, pythonOlder
, setuptools
, structlog
, tomli
, tornado
}:

buildPythonPackage rec {
  pname = "nvchecker";
<<<<<<< HEAD
  version = "2.12";
=======
  version = "2.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-6mhVDC2jpIIOZeoKz4AxxU7jj8dqPVBKRWupbuY/T7E=";
=======
    hash = "sha256-b/EGn26gTpnYuy2h6shnJI1dRwhl41eKJHzDJoFG1YI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  propagatedBuildInputs = [
    aiohttp
    platformdirs
    packaging
    pycurl
    setuptools
    structlog
<<<<<<< HEAD
    tornado
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  __darwinAllowLocalNetworking = true;

=======
    tomli
    tornado
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    flaky
    pytest-asyncio
    pytest-httpbin
    pytestCheckHook
  ];

  postBuild = ''
    patchShebangs docs/myrst2man.py
    make -C docs man
  '';

  postInstall = ''
    installManPage docs/_build/man/nvchecker.1
  '';

  pythonImportsCheck = [
    "nvchecker"
  ];

  pytestFlagsArray = [
    "-m 'not needs_net'"
  ];

  meta = with lib; {
<<<<<<< HEAD
    description = "New version checker for software";
    homepage = "https://github.com/lilydjwg/nvchecker";
    changelog = "https://github.com/lilydjwg/nvchecker/releases/tag/v${version}";
=======
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
