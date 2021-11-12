{ lib
, attrs
, buildPythonPackage
, defusedxml
, fetchFromGitHub
, hypothesis
, isPy3k
, jbig2dec
, lxml
, mupdf
, pillow
, psutil
, pybind11
, pytest-xdist
, pytestCheckHook
, python-dateutil
, python-xmp-toolkit
, qpdf
, setuptools
, setuptools-scm
, setuptools-scm-git-archive
, substituteAll
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "3.2.0";
  disabled = ! isPy3k;

  src = fetchFromGitHub {
    owner = "pikepdf";
    repo = "pikepdf";
    rev = "v${version}";
    # The content of .git_archival.txt is substituted upon tarball creation,
    # which creates indeterminism if master no longer points to the tag.
    # See https://github.com/jbarlow83/OCRmyPDF/issues/841
    extraPostFetch = ''
      rm "$out/.git_archival.txt"
    '';
    sha256 = "03c7ihd6rf6kdfc3cpgxy5pi6cj4zwscz8nyxmmp15fmdk3hkw4g";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      jbig2dec = "${lib.getBin jbig2dec}/bin/jbig2dec";
      mudraw = "${lib.getBin mupdf}/bin/mudraw";
    })
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    pybind11
    qpdf
  ];

  nativeBuildInputs = [
    setuptools-scm-git-archive
    setuptools-scm
  ];

  checkInputs = [
    attrs
    hypothesis
    pytest-xdist
    psutil
    pytestCheckHook
    python-dateutil
    python-xmp-toolkit
  ];

  propagatedBuildInputs = [
    defusedxml
    lxml
    pillow
    setuptools
  ];

  pythonImportsCheck = [ "pikepdf" ];

  meta = with lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kiwi dotlambda ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${version}/docs/release_notes.rst";
  };
}
