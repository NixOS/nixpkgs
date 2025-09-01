{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cxxopts,
  setuptools,
  pybind11,
  zlib,
  nlohmann_json,
  utf8cpp,
  libjpeg,
  qpdf,
  loguru-cpp,
  # python dependencies
  tabulate,
  pillow,
  pydantic,
  docling-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "docling-parse";
  version = "4.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-parse";
    tag = "v${version}";
    hash = "sha256-0X9fP2PiHjZs+RT+VngHvNt4U0zpXq09BnaO/5tpfY8=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  build-system = [
    setuptools
  ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev utf8cpp}/include/utf8cpp";

  buildInputs = [
    pybind11
    cxxopts
    libjpeg
    loguru-cpp
    nlohmann_json
    qpdf
    utf8cpp
    zlib
  ];

  env.USE_SYSTEM_DEPS = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_DEPS=True"
  ];

  dependencies = [
    tabulate
    pillow
    pydantic
    docling-core
  ];

  pythonRelaxDeps = [
    "pydantic"
    "pillow"
  ];

  # Listed as runtime dependencies but only used in CI to build wheels
  preBuild = ''
    sed -i '/cibuildwheel/d' pyproject.toml
    sed -i '/delocate/d' pyproject.toml
  '';

  pythonImportsCheck = [
    "docling_parse"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/DS4SD/docling-parse/blob/${src.tag}/CHANGELOG.md";
    description = "Simple package to extract text with coordinates from programmatic PDFs";
    homepage = "https://github.com/DS4SD/docling-parse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
