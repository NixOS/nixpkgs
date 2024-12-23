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
  substituteAll,
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "9.4.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    rev = "refs/tags/v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-J/ipkKqZifkWtgv7z/MJPwRK+yB7MP/19PDdjV1NMpY=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
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
    changelog = "https://github.com/pikepdf/pikepdf/blob/${src.rev}/docs/releasenotes/version${lib.versions.major version}.rst";
  };
}
