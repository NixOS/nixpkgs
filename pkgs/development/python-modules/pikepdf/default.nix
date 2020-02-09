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
  version = "1.10.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qa4sam1kvglwqwk573mjpsy8cy89yamr4val0g80hq1ribc56ah";
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
    sed -i \
      -e 's/^pytest .*/pytest/g' \
      -e 's/^attrs .*/attrs/g' \
      -e 's/^hypothesis .*/hypothesis/g' \
      requirements/test.txt
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
