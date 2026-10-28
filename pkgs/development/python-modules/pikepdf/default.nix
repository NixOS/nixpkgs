{
  lib,
  stdenv,
  attrs,
  buildPythonPackage,
  clang-tools,
  cmake,
  fetchFromGitHub,
  fonttools,
  hypothesis,
  jbig2dec,
  jsonschema,
  deprecated,
  lxml,
  withMupdf ? false,
  mupdf-headless,
  nanobind,
  ninja,
  numpy,
  packaging,
  pillow,
  psutil,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  python-xmp-toolkit,
  qpdf,
  referencing,
  replaceVars,
  scikit-build-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pikepdf";
  version = "10.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    tag = "v${finalAttrs.version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-r8r/WZ2mUox+rODGUOFXVgldKw8FwqeD94xKRmOlB1k=";
  };

  patches = [
    (replaceVars ./paths.patch {
      jbig2dec = lib.getExe' jbig2dec "jbig2dec";
      mutool =
        if withMupdf then
          lib.getExe' mupdf-headless "mutool"
        else
          # replace with non-existing path. This is okay, as this is only
          # called by Jupyter/iPython
          "mutool";
    })
  ];

  buildInputs = [ qpdf ];

  build-system = [
    cmake
    nanobind
    ninja
    scikit-build-core
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # Pick up the `clang-scan-deps` wrapper for CMake; see:
    #
    # * <https://github.com/NixOS/nixpkgs/issues/452260>
    # * <https://github.com/NixOS/nixpkgs/pull/514323>
    clang-tools
  ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [
    attrs
    hypothesis
    numpy
    pytest-xdist
    psutil
    pytestCheckHook
    python-dateutil
    python-xmp-toolkit
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  dependencies = [
    deprecated
    lxml
    packaging
    pillow
  ];

  optional-dependencies = {
    pdfa = [
      fonttools
      jsonschema
      referencing
    ];
  };

  pythonImportsCheck = [ "pikepdf" ];

  disabledTests = [
    # timezone issues in sandbox
    "test_assume_local_time_zone_for_dates"
    "test_declare_docinfo_agrees_and_validates"
    "test_declare_properties"
    "test_prepare_keeps_partial_docinfo_dates"
  ];

  meta = {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${finalAttrs.src.tag}/docs/releasenotes/version${lib.versions.major finalAttrs.version}.md";
  };
})
