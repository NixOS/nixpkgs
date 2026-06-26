{
  lib,
  attrs,
  buildPythonPackage,
  cmake,
  fetchFromGitHub,
  hypothesis,
  jbig2dec,
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
  replaceVars,
  scikit-build-core,
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "10.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    tag = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-ih5QC6VVl7dGvamp3FRzahnpEDjdO8gGFNVX19Bu8LE=";
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
  ];

  dependencies = [
    deprecated
    lxml
    packaging
    pillow
  ];

  pythonImportsCheck = [ "pikepdf" ];

  meta = {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${src.tag}/docs/releasenotes/version${lib.versions.major version}.md";
  };
}
