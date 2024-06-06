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
  memstreamHook,

  # dependencies
  mupdf,

  # tests
  fonttools,
  pytestCheckHook,
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
  version = "1.23.26";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "PyMuPDF";
    rev = "refs/tags/${version}";
    hash = "sha256-m2zq04+PDnlzFuqeSt27UhdHXTHxpHdMPIg5RQl/5bQ=";
  };

  # swig is not wrapped as Python package
  # libclang calls itself just clang in wheel metadata
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"swig",' "" \
      --replace-fail "libclang" "clang"
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
  ] ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];

  propagatedBuildInputs = [ mupdf-cxx ];

  env = {
    # force using system MuPDF (must be defined in environment and empty)
    PYMUPDF_SETUP_MUPDF_BUILD = "";
    # provide MuPDF paths
    PYMUPDF_MUPDF_LIB = "${lib.getLib mupdf-cxx}/lib";
    PYMUPDF_MUPDF_INCLUDE = "${lib.getDev mupdf-cxx}/include";
  };

  # TODO: manually add mupdf rpath until upstream fixes it
  postInstall = lib.optionalString stdenv.isDarwin ''
    for lib in */*.so $out/${python.sitePackages}/*/*.so; do
      install_name_tool -add_rpath ${lib.getLib mupdf-cxx}/lib "$lib"
    done
  '';

  nativeCheckInputs = [
    pytestCheckHook
    fonttools
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests =
    [
      # fails for indeterminate reasons
      "test_2548"
      "test_2753"
      "test_3020"
      "test_3050"
      "test_3058"
      "test_3177"
      "test_3186"
      "test_color_count"
      "test_pilsave"
      "test_fz_write_pixmap_as_jpeg"
      # NotImplementedError
      "test_1824"
      "test_2093"
      "test_2093"
      "test_2108"
      "test_2182"
      "test_2182"
      "test_2246"
      "test_2270"
      "test_2270"
      "test_2391"
      "test_2788"
      "test_2861"
      "test_2871"
      "test_2886"
      "test_2904"
      "test_2922"
      "test_2934"
      "test_2957"
      "test_2969"
      "test_3070"
      "test_3131"
      "test_3140"
      "test_3209"
      "test_3209"
      "test_caret"
      "test_deletion"
      "test_file_info"
      "test_line"
      "test_page_links_generator"
      "test_polyline"
      "test_redact"
      "test_techwriter_append"
      "test_text2"
      # Issue with FzArchive
      "test_htmlbox"
      "test_2246"
      "test_3140"
      "test_fit_springer"
      "test_write_stabilized_with_links"
      "test_textbox"
      "test_delete_image"
      # Fonts not available
      "test_fontarchive"
      "test_subset_fonts"
      # Exclude lint tests
      "test_flake8"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # darwin does not support OCR right now
      "test_tesseract"
    ];

  disabledTestPaths = [
    # Issue with FzArchive
    "tests/test_docs_samples.py"
  ];

  pythonImportsCheck = [
    "fitz"
    "fitz_old"
  ];

  meta = with lib; {
    description = "Python bindings for MuPDF's rendering library";
    homepage = "https://github.com/pymupdf/PyMuPDF";
    changelog = "https://github.com/pymupdf/PyMuPDF/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ teto ];
    platforms = platforms.unix;
  };
}
