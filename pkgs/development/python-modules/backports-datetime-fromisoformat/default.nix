{ buildPythonPackage, fetchFromGitHub, lib, pytz, nose }:

buildPythonPackage rec {
  pname = "backports-datetime-fromisoformat";
  version = "1.0.0";

  # No tests in Pypi distribution
  src = fetchFromGitHub {
    owner = "movermeyer";
    repo = "backports.datetime_fromisoformat";
    rev = "v1.0.0";
    sha256 = "0bj10ab5b15wdjhngi9hcmyy3y18dqi9c3x9573f8c9n145zs39p";
  };

  checkInputs = [ pytz nose ];
  checkPhase = "nosetests";

  meta = with lib; {
    description = "A backport of Python 3.7's `datetime.fromisoformat` methods to earlier versions of Python";
    license = licenses.mit;
    homepage = https://github.com/movermeyer/backports.datetime_fromisoformat;
    maintainers = with maintainers; [ mredaelli ];
  };

}
