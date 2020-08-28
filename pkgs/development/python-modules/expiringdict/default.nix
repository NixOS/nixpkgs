{ stdenv, buildPythonPackage, fetchFromGitHub, python, nose, mock, coveralls, dill }:

buildPythonPackage rec {
  pname = "expiringdict";
  version = "1.2.1";
  disabled = !python.isPy3k;

  src = fetchFromGitHub {
    owner = "mailgun";
    repo = "expiringdict";
    rev = "v${version}";
    sha256 = "07g1vxznmim78bankfl9brr01s31sksdcpwynq1yryh6xw9ri5xs";
  };

  checkInputs = [ coveralls dill mock nose ];
  checkPhase = ''
    nosetests -v
  '';

  meta = with stdenv.lib; {
    description = "Dictionary with auto-expiring values for caching purposes";
    homepage = "https://github.com/mailgun/expiringdict";
    license = licenses.asl20;
    maintainers = with maintainers; [ fadenb ];
  };
}
