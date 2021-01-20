{ attrs
, buildPythonPackage
, defusedxml
, fetchPypi
, hypothesis
, isPy3k
, lxml
, pillow
, pybind11
, pytestCheckHook
, pytest-helpers-namespace
, pytest-timeout
, pytest_xdist
, pytestrunner
, python-dateutil
, python-xmp-toolkit
, python3
, qpdf
, setuptools-scm-git-archive
, setuptools_scm
, lib, stdenv
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "2.2.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "74300a32c41b3d578772f6933f23a88b19f74484185e71e5225ce2f7ea5aea78";
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
    pytestCheckHook
    pytest-helpers-namespace
    pytest-timeout
    pytest_xdist
    pytestrunner
    python-dateutil
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

  meta = with lib; {
    homepage = "https://github.com/pikepdf/pikepdf";
    description = "Read and write PDFs with Python, powered by qpdf";
    license = licenses.mpl20;
    maintainers = [ maintainers.kiwi ];
  };
}
