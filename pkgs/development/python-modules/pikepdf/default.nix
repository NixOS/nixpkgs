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
  version = "1.8.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pxcx3xc6c0plgxa4w9sjdf4rs1sxpx152b1vqvad2i3392n77ga";
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
