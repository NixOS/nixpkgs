{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pythonOlder
, jbig2dec
, deprecated
, lxml
, mupdf-headless
, numpy
, packaging
, pillow
, psutil
, pybind11
, pytest-xdist
, pytestCheckHook
, python-dateutil
, python-xmp-toolkit
, qpdf
, setuptools
, substituteAll
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "8.11.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    rev = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    postFetch = ''
      rm "$out/.git_archival.txt"
    '';
    hash = "sha256-mxUXXD7/ERC6mfmLLo+zdsVblIplrlcnzTNQ7YUk3Q4=";
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
      --replace "shims_enabled = not cflags_defined" "shims_enabled = False"
  '';

  buildInputs = [
    qpdf
  ];

  nativeBuildInputs = [
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

  propagatedBuildInputs = [
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
    maintainers = with maintainers; [ kiwi dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${src.rev}/docs/releasenotes/version${lib.versions.major version}.rst";
  };
}
