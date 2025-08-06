{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cxxopts,
  poetry-core,
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
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-parse";
    tag = "v${version}";
    hash = "sha256-1vl5Ij25NXAwhoXLJ35lcr5r479jrdKd9DxWhYbCApw=";
  };

  patches = [
    # Fixes test_parse unit tests
    # export_to_textlines in docling-core >= 2.38.2 includes text direction
    # by default, which is not included in upstream's groundtruth data.
    # TODO: remove when docling-core version gets bumped in upstream's uv.lock
    ./test_parse.patch
  ];

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  build-system = [
    poetry-core
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
    maintainers = with lib.maintainers; [ drupol ];
  };
}
