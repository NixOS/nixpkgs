{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "1.0.0";

  src = fetchFromGitHub {
     owner = "movermeyer";
     repo = "backports.datetime_fromisoformat";
     rev = "v1.0.0";
     sha256 = "0bj10ab5b15wdjhngi9hcmyy3y18dqi9c3x9573f8c9n145zs39p";
  };

  # no tests in pypi package
  doCheck = false;

  pythonImportsCheck = [ "backports.datetime_fromisoformat" ];

  meta = with lib; {
    description = "Backport of Python 3.7's datetime.fromisoformat";
    homepage = "https://github.com/movermeyer/backports.datetime_fromisoformat";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
