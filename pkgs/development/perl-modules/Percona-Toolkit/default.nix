{ lib
, fetchFromGitHub
, buildPerlPackage
, shortenPerlShebang
, DBDmysql
, DBI
, IOSocketSSL
, TermReadKey
, go
,
}:

buildPerlPackage rec {
  pname = "Percona-Toolkit";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "sha256-NtyUm6swKru2VkBD+WzRN99oC3dGVguZWgFZxcOUv7E";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [ shortenPerlShebang ];

  buildInputs = [
    go
    DBDmysql
    DBI
    IOSocketSSL
    TermReadKey
  ];

  # workaround for
  # failed to initialize build cache at /homeless-shelter/Library/Caches/go-build: mkdir /homeless-shelter: read-only file system
  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    shortenPerlShebang $(grep -l "/bin/env perl" $out/bin/*)
  '';

  meta = {
    description = "Collection of advanced command-line tools to perform a variety of MySQL and system tasks";
    homepage = "https://www.percona.com/software/database-tools/percona-toolkit";
    changelog = "https://docs.percona.com/percona-toolkit/release_notes.html";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [
      izorkin
      michaelglass
    ];
  };
}
