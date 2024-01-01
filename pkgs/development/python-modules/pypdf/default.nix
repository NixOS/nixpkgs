{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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
, cryptography
, pillow

# tests
, pytestCheckHook
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "pypdf";
  version = "3.16.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-vE5ujknMpufBuwWqtjkLegTRe4eDAvBVPCVM6It2pHQ=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-46250.patch";
      url = "https://github.com/py-pdf/pypdf/commit/9b23ac3c9619492570011d551d521690de9a3e2d.patch";
      hash = "sha256-A6UEJzDAcDBoMirfow7oXLFAaDG/j4QXEHGbHBgoZA4=";
    })
  ];

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
      cryptography
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
    pytest-timeout
  ] ++ passthru.optional-dependencies.full;

  pytestFlagsArray = [
    # don't access the network
    "-m" "'not enable_socket'"
  ];

  disabledTests = [
    # requires fpdf2 which we don't package yet
    "test_compression"
  ];

  meta = with lib; {
    description = "A pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
