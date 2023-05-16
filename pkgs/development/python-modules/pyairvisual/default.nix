{ lib
, aiohttp
, aresponses
, buildPythonPackage
<<<<<<< HEAD
, certifi
, fetchFromGitHub
, fetchpatch
, numpy
, poetry-core
, pygments
=======
, fetchFromGitHub
, numpy
, poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pysmb
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyairvisual";
<<<<<<< HEAD
  version = "2023.08.1";
=======
  version = "2022.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-+yqN3q+uA/v01uCguzUSoeCJK9lRmiiYn8d272+Dd2M=";
  };

  patches = [
    # https://github.com/bachya/pyairvisual/pull/298
    (fetchpatch {
      name = "clean-up-build-dependencies.patch";
      url = "https://github.com/bachya/pyairvisual/commit/eb32beb7229a53ff81917cc417ed66b26aae47dd.patch";
      hash = "sha256-RLRbHmaR2A8MNc96WHx0L8ccyygoBUaOulAuRJkFuUM=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml --replace \
      'certifi = ">=2023.07.22"' \
      'certifi = "*"'
  '';

=======
    hash = "sha256-xzTho4HsIU2YLURz9DfFfaRL3tsrtVi8n5IA2bRkyzw=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
<<<<<<< HEAD
    certifi
    numpy
    pygments
    pysmb
  ];

  # this lets tests bind to localhost in sandbox mode on macOS
  __darwinAllowLocalNetworking = true;

=======
    numpy
    pysmb
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Ignore the examples directory as the files are prefixed with test_.
    "examples/"
  ];

  pythonImportsCheck = [
    "pyairvisual"
  ];

  meta = with lib; {
    description = "Python library for interacting with AirVisual";
    homepage = "https://github.com/bachya/pyairvisual";
    changelog = "https://github.com/bachya/pyairvisual/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
