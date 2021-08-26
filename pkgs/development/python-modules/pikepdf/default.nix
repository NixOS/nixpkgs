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
  version = "2.16.1";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4k3/avMfHrcy/LXbRniDXR8xJkOZb9zZ2+uKylK8Dd4=";
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
