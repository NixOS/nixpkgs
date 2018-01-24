{ stdenv, buildPythonPackage, fetchPypi, snowballstemmer, configparser,
  pytest, pytestpep8, mock, pathlib }:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ssv8l6cvrmzgwcdzw76rnl4np3qf0dbwr1wsx76y0hc7lwsnsd";
  };

  propagatedBuildInputs = [ snowballstemmer configparser ];

  checkInputs = [ pytest pytestpep8 mock pathlib ];

  meta = with stdenv.lib; {
    description = "Python docstring style checker";
    homepage = https://github.com/PyCQA/pydocstyle/;
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
