{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  cmake,
  setuptools,
  nanobind,
  furo,
  ipython,
  myst-parser,
  sphinxHook,
  sphinx-autodoc-typehints,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "pypcode";
  version = "3.3.3";

  pyproject = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  sphinxBuilders = [
    "html"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "angr";
    repo = "pypcode";
    rev = "v${version}";
    hash = "sha256-m3Ee1n6TIbcihTwz1ihpn10gC1YsSlFO17Gj0QVya2A=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    sphinxHook
    furo
    ipython
    myst-parser
    sphinx-autodoc-typehints
  ];

  build-system = [
    cmake
    setuptools
    nanobind
  ];

  # remove source headers
  postInstall = ''
    rm -rf $out/${python.sitePackages}/pypcode/{sleigh,zlib}
    rm -f $out/${python.sitePackages}/pypcode/*.{c,cpp,h,hpp}
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [
    "pypcode"
  ];

  preCheck = ''
    rm -rf pypcode
  '';

  pytestFlagsArray = [
    "--no-cov"
  ];

  meta = with lib; {
    description = "Machine code disassembly and IR translation library";
    homepage = "https://api.angr.io/projects/pypcode/en/latest/";
    changelog = "https://github.com/angr/pypcode/releases";
    license = with licenses; [
      bsd2
      asl20
      zlib
    ];
    maintainers = with maintainers; [ misaka18931 ];
  };
}
