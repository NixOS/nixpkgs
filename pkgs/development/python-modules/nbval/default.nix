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
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f18b87af4e94ccd073263dd58cd3eebabe9f5e4d6ab535b39d3af64811c7eda";
  };

  LC_ALL = "en_US.UTF-8";

  buildInputs = [ glibcLocales ];
  checkInputs = [ matplotlib sympy pytestcov ];
  propagatedBuildInputs = [ coverage ipykernel jupyter_client nbformat pytest six ];

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
