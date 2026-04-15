{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jbig2dec,
  deprecated,
  lxml,
  withMupdf ? false,
  mupdf-headless,
  numpy,
  packaging,
  pillow,
  psutil,
  pybind11,
  pytest-xdist,
  pytestCheckHook,
  python-dateutil,
  python-xmp-toolkit,
  qpdf,
  setuptools,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "10.3.0";
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
    hash = "sha256-fEIzmC17RYic4CFwBh5FdGbJmaWaiaPBK7eCQ7RCmr0=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "shims_enabled = not cflags_defined" "shims_enabled = False"
  '';

  buildInputs = [ qpdf ];

  build-system = [
    pybind11
    setuptools
  ];

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
