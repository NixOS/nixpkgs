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

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];
  checkInputs = [ matplotlib sympy pytestcov pytest ];
  propagatedBuildInputs = [ coverage ipykernel jupyter_client nbformat pytest six ];

  # ignore impure tests
  checkPhase = ''
    pytest tests --current-env --ignore tests/test_timeouts.py
  '';

  meta = with lib; {
    description = "A py.test plugin to validate Jupyter notebooks";
    homepage = https://github.com/computationalmodelling/nbval;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
