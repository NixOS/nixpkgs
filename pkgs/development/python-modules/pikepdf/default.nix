{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  pythonOlder,
  jbig2dec,
  deprecated,
  lxml,
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
  version = "10.0.2";
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
    hash = "sha256-ncWgIcQp6/GOrNwIvwJ4nvf+SUfr0N53MXYq9LpfiB4=";
  };

  patches = [
    (replaceVars ./paths.patch {
      jbig2dec = lib.getExe' jbig2dec "jbig2dec";
      mutool = lib.getExe' mupdf-headless "mutool";
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

  meta = with lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${src.tag}/docs/releasenotes/version${lib.versions.major version}.md";
  };
}
