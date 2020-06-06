{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, mock
, pytest
, pytestpep8
, snowballstemmer
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "5.0.2";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "03z8miyppm2xncrc9yjilwl7z5c5cpv51zha580v64p8sb2l0j7j";
  };

  propagatedBuildInputs = [ snowballstemmer ];

  checkInputs = [ pytest pytestpep8 mock ];

  checkPhase = ''
    # test_integration.py installs packages via pip
    py.test --pep8 --cache-clear -vv src/tests -k "not test_integration"
  '';

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = "https://github.com/PyCQA/pydocstyle/";
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
