{ lib, buildPythonPackage, fetchFromGitHub, isPy27, pytest, pytest-flake8, pytest-isort, pytest-mock, pytz }:

buildPythonPackage rec {
  pname = "mimesis";
  version = "3.3.0";
  disabled = isPy27;
  
  src = fetchFromGitHub {
    owner = "lk-geimfari";
    repo = "mimesis";
    rev = "v" + version;
    sha256 = "0rqbpqznp5d54nfdyazywb9vw6v38vzcbkfwl0h2d2l48fc0mifh";
  };
  
  propagatedBuildInputs = [ pytz ];
  
  checkInputs = [ pytest pytest-flake8 pytest-isort pytest-mock ];
  
  checkPhase = ''
    # deselect test_download_image and test_stock_image: the tests require access to external network
    # deselect test_cpf_with_666_prefix: mocker cannot be used as context manager
    pytest tests -k 'not test_download_image and not test_stock_image and not test_cpf_with_666_prefix' 
  '';
  
  meta = with lib; {
    description = "Fake data generator";
    homepage = "https://github.com/lk-geimfari/mimesis";
    license = licenses.mit;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
