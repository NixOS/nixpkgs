{ lib, fetchFromGitHub, buildPerlPackage, shortenPerlShebang
, DBDmysql, DBI, IOSocketSSL, TermReadKey
}:

buildPerlPackage rec {
  pname = "Percona-Toolkit";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "084ldpskvlfm32lfss5qqzm5y9b8hf029aa4i5pcnzgb53xaxkqx";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ shortenPerlShebang ];

  buildInputs = [ DBDmysql DBI IOSocketSSL TermReadKey ];

  postInstall = ''
    shortenPerlShebang $(grep -l "/bin/env perl" $out/bin/*)
  '';

  meta = {
    description = "Collection of advanced command-line tools to perform a variety of MySQL and system tasks";
    homepage = "https://www.percona.com/software/database-tools/percona-toolkit";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
