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
, setuptools-scm
, setuptools-scm-git-archive
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "2.8.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "74ff96fddd21cd4c0830eb549137ea9eccbdbff8cef4f684322b9afb8e42ccb5";
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
  };
}
