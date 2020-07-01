{ lib, fetchFromGitHub, buildPerlPackage, DBDmysql, DBI, IOSocketSSL, TermReadKey, shortenPerlShebang }:

buildPerlPackage {
  pname = "Percona-Toolkit";
  version = "3.0.12";
  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "3.0.12";
    sha256 = "0xk4h4dzl80kf97lbx0nznx9ajrb6kkg7k3iwca3rj6f3rqggv9y";
  };
  outputs = [ "out" ];
  nativeBuildInputs = [ shortenPerlShebang ];
  buildInputs = [ DBDmysql DBI IOSocketSSL TermReadKey ];
  postInstall = ''
    shortenPerlShebang $(grep -l "/bin/env perl" $out/bin/*)
  '';
  meta = {
    description = ''Collection of advanced command-line tools to perform a variety of MySQL and system tasks.'';
    homepage = "http://www.percona.com/software/percona-toolkit";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
