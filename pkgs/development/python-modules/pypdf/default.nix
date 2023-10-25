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
, pycryptodome
, pillow

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pypdf";
  version = "3.5.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-f+M4sfUzDy8hxHUiWG9hyu0EYvnjNA46OtHzBSJdID0=";
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
      pycryptodome
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
  ] ++ passthru.optional-dependencies.full;

  pytestFlagsArray = [
    # don't access the network
    "-m" "'not enable_socket'"
  ];

  meta = with lib; {
    description = "A pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
