{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  python,

  # build-system
  libclang,
  psutil,
  setuptools,
  swig,

  # native dependencies
  freetype,
  harfbuzz,
  openjpeg,
  jbig2dec,
  libjpeg_turbo,
  gumbo,

  # dependencies
  mupdf,

  # tests
  pytestCheckHook,
  fonttools,
  pillow,
  pymupdf-fonts,
}:

let
  # PyMuPDF needs the C++ bindings generated
  mupdf-cxx = mupdf.override {
    enableOcr = true;
    enableCxx = true;
    enablePython = true;
    python3 = python;
  };
in
buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.24.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "PyMuPDF";
    rev = "refs/tags/${version}";
    hash = "sha256-M7Ca3nqnqeClp4MGJqTAVGZhAGRniregjRrjtAhRkBc=";
  };

  # swig is not wrapped as Python package
  # libclang calls itself just clang in wheel metadata
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "ret.append( 'swig')" "pass" \
  '';

  nativeBuildInputs = [
    libclang
    swig
    psutil
    setuptools
  ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg_turbo
    gumbo
  ];

  propagatedBuildInputs = [ mupdf-cxx ];

  env = {
    # force using system MuPDF (must be defined in environment and empty)
    PYMUPDF_SETUP_MUPDF_BUILD = "";
    # Setup the name of the package away from the default 'libclang'
    PYMUPDF_SETUP_LIBCLANG = "clang";
    # provide MuPDF paths
    PYMUPDF_MUPDF_LIB = "${lib.getLib mupdf-cxx}/lib";
    PYMUPDF_MUPDF_INCLUDE = "${lib.getDev mupdf-cxx}/include";
  };

  # TODO: manually add mupdf rpath until upstream fixes it
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for lib in */*.so $out/${python.sitePackages}/*/*.so; do
      install_name_tool -add_rpath ${lib.getLib mupdf-cxx}/lib "$lib"
    done
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    fonttools
    pillow
    pymupdf-fonts
  ];

  disabledTests = [
    # Do not lint code
    "test_codespell"
    "test_pylint"
    "test_flake8"
    # Upstream recommends disabling these when not using bundled MuPDF build
    "test_color_count"
    "test_3050"
    "test_textbox3"
  ];

  pythonImportsCheck = [
    "pymupdf"
    "fitz"
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH";
  '';

  meta = {
    description = "Python bindings for MuPDF's rendering library";
    homepage = "https://github.com/pymupdf/PyMuPDF";
    changelog = "https://github.com/pymupdf/PyMuPDF/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ teto ];
    platforms = lib.platforms.unix;
  };
}
