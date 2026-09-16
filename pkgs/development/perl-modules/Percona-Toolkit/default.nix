{
  lib,
  fetchFromGitHub,
  buildPerlPackage,
  DBDmysql,
  DBI,
  IOSocketSSL,
  TermReadKey,
  go,
  buildGoModule,
  git,
}:

let
  version = "3.7.1-4";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "sha256-5mdRkdRSXhqdhJ0+pgQD18DS30WyvY2h6oImO4Fhljs=";

    # needed for build script
    leaveDotGit = true;
  };

  goDeps =
    (buildGoModule {
      pname = "Percona-Toolkit go-bindings";
      inherit src version;

      vendorHash = "sha256-LdUWZdoKVsYcL6DO0U18pHMmF4D+5PwMdlJf416H4hA=";
    }).goModules;
in
buildPerlPackage {
  pname = "Percona-Toolkit";

  inherit src version;

  outputs = [ "out" ];

  nativeBuildInputs = [
    git
  ];

  buildInputs = [
    DBDmysql
    go
    DBI
    IOSocketSSL
    TermReadKey
  ];

  postPatch = ''
    cp -r --reflink=auto ${goDeps} vendor
    chmod -R u+rw vendor
    substituteInPlace src/go/Makefile \
      --replace-fail "go get ./..." "echo 'Skipping go get due to offline build'"
  '';

  preBuild = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Collection of advanced command-line tools to perform a variety of MySQL and system tasks";
    homepage = "https://www.percona.com/software/database-tools/percona-toolkit";
    changelog = "https://docs.percona.com/percona-toolkit/release_notes.html";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
