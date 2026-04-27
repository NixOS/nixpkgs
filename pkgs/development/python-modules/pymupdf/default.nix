{
  lib,
  stdenv,
  buildPythonPackage,
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
buildPythonPackage (finalAttrs: {
  pname = "pymupdf";
  version = "1.27.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymupdf";
    repo = "PyMuPDF";
    tag = finalAttrs.version;
    hash = "sha256-o70IMa64jjX+b83uW4gISOiNrWtefQ8nc8Z99DfqrQI=";
  };

  patches = [
    # `conftest.py` tries to run `pip install` to install test dependencies.
    ./conftest-dont-pip-install.patch
  ];

  # swig is not wrapped as Python package
  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "ret.append('swig')" "pass" \
      --replace-fail "ret.append('swig==4.3.1')" "pass"
  '';

  # `build_extension` passes arguments to `$LD` that are meant for `c++`.
  # When `LD` is not set, `build_extension` falls back to using `c++` in `PATH`.
  # See https://github.com/pymupdf/PyMuPDF/blob/1.26.6/pipcl.py#L1998 for details.
  preConfigure = ''
    unset LD
  '';

  build-system = [
    libclang
    swig
    setuptools
  ];

  dependencies = [
    mupdf-cxx-lib
  ];

  buildInputs = [
    freetype
    harfbuzz
    openjpeg
    jbig2dec
    libjpeg_turbo
    gumbo
  ];

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
    fonttools
    pillow
    psutil
    pymupdf-fonts
  ];

  disabledTests = [
    # Do not lint code
    "test_codespell"
    "test_pylint"
    "test_flake8"
    "test_4751"
    # Upstream recommends disabling these when not using bundled MuPDF build
    "test_color_count"
    "test_3050"
    "test_textbox3"
    "test_3493"
    "test_4180"
    # Requires downloads
    "test_4457"
    "test_4445"
    "test_4533"
    "test_4702"
    # Not a git repository, so git ls-files fails
    "test_open2"
    # Segfaults in test_general.py::test_4907 with system MuPDF
    "test_4907"
  ];

  disabledTestPaths = [
    # mad about markdown table formatting
    "tests/test_tables.py::test_markdown"

    # Do not lint code
    "tests/test_typing.py"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    # Trace/BPT trap: 5 when getting widget options
    "tests/test_4505.py"
    "tests/test_widgets.py"
    # https://github.com/pymupdf/PyMuPDF/issues/4988 triggered by
    # https://github.com/swig/swig/issues/3279
    "tests/test_font.py::test_load_system_font"
    "tests/test_general.py::test_add_ink_annot"
    "tests/test_general.py::test_2533"
    "tests/test_general.py::test_2506"
    "tests/test_general.py::test_2093"
    "tests/test_general.py::test_2430"
    "tests/test_general.py::test_2553"
    "tests/test_general.py::test_2736"
    "tests/test_general.py::test_subset_fonts"
    "tests/test_general.py::test_2957_2"
    "tests/test_general.py::test_707560"
    "tests/test_general.py::test_3140"
    "tests/test_general.py::test_3654"
    "tests/test_general.py::test_3624"
    "tests/test_general.py::test_4415"
    "tests/test_general.py::test_4496"
    "tests/test_general.py::test_4590"
    "tests/test_general.py::test_4712"
    "tests/test_general.py::test_4712m"
    "tests/test_general.py::test_4902"
    "tests/test_imagebbox.py::test_bboxlog"
    "tests/test_imagebbox.py::test_image_bbox"
    "tests/test_insertpdf.py::test_issue1417_insertpdf_in_loop"
    "tests/test_mupdf_regressions.py::test_707673"
    "tests/test_mupdf_regressions.py::test_3376"
    "tests/test_nonpdf.py::test_pageids"
    "tests/test_objectstreams.py::test_objectstream1"
    "tests/test_objectstreams.py::test_objectstream2"
    "tests/test_objectstreams.py::test_objectstream3"
    "tests/test_pagedelete.py::test_3094"
    "tests/test_pixmap.py::test_pdfpixmap"
    "tests/test_pixmap.py::test_3854"
    "tests/test_pixmap.py::test_4155"
    "tests/test_pixmap.py::test_4699"
    "tests/test_remove-rotation.py::test_remove_rotation"
    "tests/test_spikes.py::test_spikes"
    "tests/test_story.py::test_story"
    "tests/test_story.py::test_2753"
    "tests/test_story.py::test_fit_springer"
    "tests/test_story.py::test_write_stabilized_with_links"
    "tests/test_story.py::test_3813"
    "tests/test_tables.py::test_2979"
    "tests/test_tables.py::test_strict_lines"
    "tests/test_tables.py::test_3148"
    "tests/test_tables.py::test_battery_file"
    "tests/test_tables.py::test_dotted_grid"
    "tests/test_textbox.py::test_textbox4"
    "tests/test_textbox.py::test_2637"
    "tests/test_textbox.py::test_htmlbox1"
    "tests/test_textbox.py::test_htmlbox2"
    "tests/test_textbox.py::test_htmlbox3"
    "tests/test_textbox.py::test_3559"
    "tests/test_textbox.py::test_3916"
    "tests/test_textbox.py::test_4613"
    "tests/test_textextract.py::test_extract4"
    "tests/test_textextract.py::test_3197"
    "tests/test_textextract.py::test_3705"
    "tests/test_textextract.py::test_4147"
    "tests/test_textextract.py::test_4179"
    "tests/test_textextract.py::test_extendable_textpage"
    "tests/test_textextract.py::test_4503"
    "tests/test_toc.py::test_simple_toc"
    "tests/test_toc.py::test_3400"
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
    changelog = "https://github.com/pymupdf/PyMuPDF/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ sarahec ];
    platforms = lib.platforms.unix;
  };
})
