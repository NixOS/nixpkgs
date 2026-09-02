{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # docs
  sphinxHook,
  sphinx-rtd-theme,
  myst-parser,

  # optionals
  arabic-reshaper,
  cryptography,
  fonttools,
  pillow,
  python-bidi,

  # tests
  fpdf2,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage rec {
  pname = "pypdf";
  version = "6.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    tag = version;
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-SgEYnhScwvWy8J7Wxp0TdGZkX++99cUs8E7+7su1zcg=";
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

  optional-dependencies = rec {
    full = crypto ++ fonts ++ image ++ rtl_text;
    crypto = [ cryptography ];
    fonts = [ fonttools ];
    image = [ pillow ];
    rtl_text = [
      arabic-reshaper
      python-bidi
    ];
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
