{ lib
, attrs
, buildPythonPackage
, defusedxml
, fetchPypi
, hypothesis
, isPy3k
, lxml
, pillow
, psutil
, pybind11
, pytest-cov
, pytest-helpers-namespace
, pytest-timeout
, pytest-xdist
, pytestCheckHook
, python-dateutil
, python-xmp-toolkit
, qpdf
, setuptools
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "2.12.2";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ff35499b1ae7b181277f78ce5b1bcc8d3009182bb389917791c5dc811fcc8e4";
  };

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
    pytest-helpers-namespace
    pytest-timeout
    pytest-xdist
    psutil
    pytest-cov
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

  preBuild = ''
    HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "pikepdf" ];

  meta = with lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = [ maintainers.kiwi ];
    changelog = "https://github.com/pikepdf/pikepdf/blob/${version}/docs/release_notes.rst";
  };
}
