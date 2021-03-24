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
  version = "2.9.1";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99c19cf0dd0fc89fc9e6a0de61e974e34d4111dd69802aeaee3e61fb1a74a3d8";
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
