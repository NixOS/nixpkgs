{ lib
, buildPythonPackage
, fetchPypi
, coverage
, ipykernel
, jupyter_client
, nbformat
, pytest
, six
, glibcLocales
, matplotlib
, sympy
, pytestcov
}:

buildPythonPackage rec {
  pname = "nbval";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g8xl4158ngyhiynrkk72jpawnk4isznbijz0w085g269fps0vp2";
  };

  checkInputs = [
    pytest
    matplotlib
    sympy
    pytestcov
  ];

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
    coverage
    ipykernel
    jupyter_client
    nbformat
    pytest
    six
  ];

  # ignore impure tests
  checkPhase = ''
    pytest tests --ignore tests/test_timeouts.py
  '';

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = https://github.com/computationalmodelling/nbval;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
