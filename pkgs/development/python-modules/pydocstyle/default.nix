{ lib, buildPythonPackage, fetchFromGitHub, isPy3k
, mock
, pytest
, pytestpep8
, snowballstemmer
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "4.0.1";
  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "1sr8d2fsfpam4f14v4als6g2v6s3n9h138vxlwhd6slb3ll14y4l";
  };

  propagatedBuildInputs = [ snowballstemmer ];

  checkInputs = [ pytest pytestpep8 mock ];

  checkPhase = ''
    # test_integration.py installs packages via pip
    py.test --pep8 --cache-clear -vv src/tests -k "not test_integration"
  '';

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = https://github.com/PyCQA/pydocstyle/;
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
