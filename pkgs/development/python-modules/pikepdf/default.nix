{ attrs
, buildPythonPackage
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
, pytestcov
, python-xmp-toolkit
, python3
, wheel
, python-dateutil
, qpdf
, setuptools-scm-git-archive
, setuptools_scm
, stdenv
}:

buildPythonPackage rec {
  pname = "pikepdf";
  version = "2.2.0";
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "dDAKMsQbPVeHcvaTPyOoixn3RIQYXnHlIlzi9+pa6ng=";
  };

  # We are not sure why these deps are pinned in setup.py, but it seems pikepdf
  # works without them updated. https://github.com/NixOS/nixpkgs/issues/105974
  # is where the update to wheel is tracked. Should be removed at some point
  # since wheel is updated in staging
  preConfigure = ''
    sed -i 's/wheel >= 0.35/wheel/g' setup.py
    sed -i 's/setuptools >= 50/setuptools/g' setup.py
  '';

  buildInputs = [
    pybind11
    qpdf
  ];

  nativeBuildInputs = [
    setuptools-scm-git-archive
    setuptools_scm
    wheel
  ];

  checkInputs = [
    attrs
    hypothesis
    pillow
    pytest
    pytest-helpers-namespace
    pytest-timeout
    pytestcov
    pytest_xdist
    pytestrunner
    python-xmp-toolkit
  ];

  propagatedBuildInputs = [ python-dateutil lxml ];

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
