{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  pythonOlder,

  # build-system
  flit-core,

  # docs
  sphinxHook,
  sphinx-rtd-theme,
  myst-parser,

  # propagates
  typing-extensions,

  # optionals
  cryptography,
  pillow,

  # tests
  fpdf2,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "pypdf";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-ziJTYl7MQUCE8US0yeiq6BPDVbBsxWhti0NyiDnKtfE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--disable-socket" ""
  '';

  build-system = [ flit-core ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
    myst-parser
  ];

  dependencies = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  optional-dependencies = rec {
    full = crypto ++ image;
    crypto = [ cryptography ];
    image = [ pillow ];
  };

  pythonImportsCheck = [ "pypdf" ];

  nativeCheckInputs = [
    (fpdf2.overridePythonAttrs { doCheck = false; }) # avoid reference loop
    pytestCheckHook
    pytest-timeout
  ] ++ optional-dependencies.full;

  pytestFlagsArray = [
    # don't access the network
    "-m"
    "'not enable_socket'"
  ];

  meta = with lib; {
    description = "Pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ javaes ];
  };
}
