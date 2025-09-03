{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  python,
  toPythonModule,

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
    enableBarcode = true;
    python3 = python;
  };
  mupdf-cxx-lib = toPythonModule (lib.getLib mupdf-cxx);
  mupdf-cxx-dev = lib.getDev mupdf-cxx;
in
buildPythonPackage rec {
  pname = "pymupdf";
  version = "1.26.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "PyMuPDF";
    tag = version;
    hash = "sha256-djTbALLvdX2jOTGgoyUIBhiqJ6KzM+Dkb4M7d2eVoPM=";
  };

  # swig is not wrapped as Python package
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

  propagatedBuildInputs = [ mupdf-cxx-lib ];

  env = {
    # force using system MuPDF (must be defined in environment and empty)
    PYMUPDF_SETUP_MUPDF_BUILD = "";
    # Setup the name of the package away from the default 'libclang'
    PYMUPDF_SETUP_LIBCLANG = "clang";
    # provide MuPDF paths
    PYMUPDF_MUPDF_LIB = "${mupdf-cxx-lib}/lib";
    PYMUPDF_MUPDF_INCLUDE = "${mupdf-cxx-dev}/include";
  };

  # TODO: manually add mupdf rpath until upstream fixes it
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for lib in */*.so $out/${python.sitePackages}/*/*.so; do
      install_name_tool -add_rpath ${mupdf-cxx-lib}/lib "$lib"
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
    "test_3493"
    "test_4180"
    # Requires downloads
    "test_4457"
    "test_4445"
    # Not a git repository, so git ls-files fails
    "test_open2"
  ];

  disabledTestPaths = [
    # mad about markdown table formatting
    "tests/test_tables.py::test_markdown"
  ];

  pythonImportsCheck = [
    "pymupdf"
    "fitz"
  ];

  preCheck = ''
    export PATH="$out/bin:$PATH";

    # Fixes at least one test; see:
    # * <https://github.com/pymupdf/PyMuPDF/blob/refs/tags/1.25.1/scripts/sysinstall.py#L390>
    # * <https://github.com/pymupdf/PyMuPDF/blob/refs/tags/1.25.1/tests/test_pixmap.py#L425-L428>
    export PYMUPDF_SYSINSTALL_TEST=1
  '';

  meta = {
    description = "Python bindings for MuPDF's rendering library";
    homepage = "https://github.com/pymupdf/PyMuPDF";
    changelog = "https://github.com/pymupdf/PyMuPDF/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
