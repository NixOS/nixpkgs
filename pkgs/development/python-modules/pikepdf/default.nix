{ attrs
, buildPythonPackage
, defusedxml
, fetchPypi
, hypothesis
, isPy3k
, lxml
, pillow
, pybind11
, pytest
, pytest-helpers-namespace
, pytest-timeout
, pytest_xdist
, pytestrunner
, python-xmp-toolkit
, python3
, qpdf
, setuptools-scm-git-archive
, setuptools_scm
, stdenv
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "1.1.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "14b36r6h3088z2sxp2pqvm171js53hz53mwm1g52iadignjnp0my";
  };

  buildInputs = [
    pybind11
    qpdf
  ];

  nativeBuildInputs = [
    setuptools-scm-git-archive
    setuptools_scm
  ];

  checkInputs = [
    attrs
    hypothesis
    pillow
    pytest
    pytest-helpers-namespace
    pytest-timeout
    pytest_xdist
    pytestrunner
    python-xmp-toolkit
  ];

  propagatedBuildInputs = [ defusedxml lxml ];

  postPatch = ''
    substituteInPlace requirements/test.txt \
       --replace "pytest >= 3.6.0, < 4.1.0" "pytest >= 4.2.1, < 5"
  '';

  preBuild = ''
    HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = [ maintainers.kiwi ];
  };
}

