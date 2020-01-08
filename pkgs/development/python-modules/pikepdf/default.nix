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
  version = "1.8.2";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n3fd7i1br1s4f90yismgfcq9ix5kcqfacr7yy0hhhrabkf2sm37";
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
