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
, cryptography
, pillow

# tests
, fpdf2
, pytestCheckHook
, pytest-timeout
}:

buildPythonPackage rec {
  pname = "pypdf";
  version = "3.17.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-2FKTBN1VZX0LGiDEghix4DBt1gO9NRNB/lAUefu5EUA=";
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
    (fpdf2.overridePythonAttrs { doCheck = false; })  # avoid reference loop
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
    # infinite recursion when including fpdf2
    "test_merging_many_temporary_files"
  ];

  meta = with lib; {
    description = "A pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
