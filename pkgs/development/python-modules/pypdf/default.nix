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
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-pdf";
    repo = "pypdf";
    rev = "refs/tags/${version}";
    # fetch sample files used in tests
    fetchSubmodules = true;
    hash = "sha256-omnNC1mzph59aqrXqLCuCk0LgzfJv/JhbQRrAgRhAIg=";
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

  patches = [
    (fetchpatch2 {
      # Mark test_increment_writer as enable_socket (https://github.com/py-pdf/pypdf/pull/2867)
      url = "https://github.com/py-pdf/pypdf/commit/d974d5c755a7b65f3b9c68c5742afdbc0c1693f6.patch";
      hash = "sha256-4xiCAStP615IktTUgk31JbIxkxx8d6PQdu8Nfmhc1jo=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--disable-socket" ""
  '';

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

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
