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
  version = "7.24.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "docling-project";
    repo = "docling-parse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wuPK41aFj285MEKeEoH64vjocv8baILXucx0ugb0EHA=";
  };

  postPatch =
    # cibuildwheel and delocate are listed as build-system dependencies but are only used in CI to
    # build wheels.
    ''
      substituteInPlace pyproject.toml \
        --replace-fail \
          "\"cibuildwheel>=4.3.0,<5.0.0; python_version >= '3.11'\"," \
          "" \
        --replace-fail \
          '"delocate>=0.11.0,<1.0.0",' \
          ""
    ''
    # Upstream vendors utfcpp 4.0.6. In newer releases (as packaged in nixpkgs), the 3-argument
    # `internal::validate_next` was renamed `internal::decode_next`.
    + ''
      substituteInPlace src/parse/pdf_resources/page_font.h \
        --replace-fail \
          "utf8::internal::validate_next(itr, value.end(), cp)" \
          "utf8::internal::decode_next(itr, value.end(), cp)"
    ''
    # The throwing `is_directory` overload aborts parsing when a font directory can't be read,
    # e.g. /System/Library/Fonts in the darwin sandbox
    + ''
      substituteInPlace src/render/blend2d_font_resolver.h \
        --replace-fail \
          "if (not fs::is_directory(dir))" \
          "if (std::error_code dir_ec; not fs::is_directory(dir, dir_ec))"
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
    changelog = "https://github.com/docling-project/docling-parse/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Simple package to extract text with coordinates from programmatic PDFs";
    homepage = "https://github.com/docling-project/docling-parse";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
