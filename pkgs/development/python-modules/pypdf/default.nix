{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build-system
, flit-core

# docs
, sphinxHook
, sphinx-rtd-theme
, myst-parser

# propagates
, typing-extensions

# optionals
<<<<<<< HEAD
, cryptography
=======
, pycryptodome
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pillow

# tests
, pytestCheckHook
<<<<<<< HEAD
, pytest-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pypdf";
<<<<<<< HEAD
  version = "3.15.1";
=======
  version = "3.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-0KMZnMIeTkra2Il4HGDBtm8HLP8zpMXgUD4V5U5fYy0=";
=======
    hash = "sha256-f+M4sfUzDy8hxHUiWG9hyu0EYvnjNA46OtHzBSJdID0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    flit-core

    # docs
    sphinxHook
    sphinx-rtd-theme
    myst-parser
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--disable-socket" ""
  '';

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  passthru.optional-dependencies = rec {
    full = crypto ++ image;
    crypto = [
<<<<<<< HEAD
      cryptography
=======
      pycryptodome
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ];
    image = [
      pillow
    ];
  };

  pythonImportsCheck = [
    "pypdf"
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    pytest-timeout
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ passthru.optional-dependencies.full;

  pytestFlagsArray = [
    # don't access the network
    "-m" "'not enable_socket'"
  ];

<<<<<<< HEAD
  disabledTests = [
    # requires fpdf2 which we don't package yet
    "test_compression"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
