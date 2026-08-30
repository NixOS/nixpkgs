{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  pybind11,
  setuptools,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  blend2d,
  cxxopts,
  freetype,
  lcms2,
  libjpeg,
  loguru-cpp,
  nlohmann_json,
  openjpeg,
  qpdf,
  utf8cpp,
  zlib,

  # dependencies
  docling-core,
  pillow,
  pydantic,
}:

buildPythonPackage (finalAttrs: {
  pname = "docling-parse";
  version = "7.8.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-parse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTXWIJWwxfBdPnoCvo1sq7o9itG/MUX3FNz1GGtvaVo=";
  };

  # cibuildwheel and delocate are listed as build-system dependencies but are only used in CI to
  # build wheels.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "cmake>=3.27.0,<4.0.0" \
        "cmake>=3.27.0" \
      --replace-fail \
        "\"cibuildwheel>=2.19.2,<4.0.0; python_version >= '3.11'\"," \
        "" \
      --replace-fail \
        '"delocate>=0.11.0,<1.0.0",' \
        ""
  '';

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = [
    cmake
    pybind11
    setuptools
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev utf8cpp}/include/utf8cpp";
    USE_SYSTEM_DEPS = "ON";
  };

  buildInputs = [
    blend2d
    cxxopts
    freetype
    lcms2
    libjpeg
    loguru-cpp
    nlohmann_json
    openjpeg
    qpdf
    utf8cpp
    zlib
  ];

  dependencies = [
    docling-core
    pillow
    pydantic
  ];

  pythonImportsCheck = [ "docling_parse" ];

  # The whole test suite requires the test corpus, which `tests/conftest.py` unconditionally
  # downloads from HuggingFace in `pytest_sessionstart`.
  doCheck = false;

  meta = {
    changelog = "https://github.com/DS4SD/docling-parse/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Simple package to extract text with coordinates from programmatic PDFs";
    homepage = "https://github.com/DS4SD/docling-parse";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
