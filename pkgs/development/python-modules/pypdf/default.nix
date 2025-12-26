{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "6.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    tag = version;
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-GkCNw7XvDPvLIiIUAgXsTLQ2OBbqhpf3xHQZpB/f2ys=";
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
  ]
  ++ optional-dependencies.full;

  disabledTestMarks = [
    # don't access the network
    "enable_socket"
  ];

  meta = {
    description = "Pure-python PDF library capable of splitting, merging, cropping, and transforming the pages of PDF files";
    homepage = "https://github.com/py-pdf/pypdf";
    changelog = "https://github.com/py-pdf/pypdf/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ javaes ];
  };
}
