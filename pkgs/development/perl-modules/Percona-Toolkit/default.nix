{
  lib,
  fetchFromGitHub,
  buildPerlPackage,
  shortenPerlShebang,
  DBDmysql,
  DBI,
  IOSocketSSL,
  TermReadKey,
  go,
  buildGoModule,
  git,
}:

let
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "sha256-fJGeL9XZHTFmpns5CE7It35HRnF3JiC6muOpOS1zboI=";

    # needed for build script
    leaveDotGit = true;
  };

  goDeps =
    (buildGoModule {
      pname = "Percona-Toolkit go-bindings";
      inherit src version;

      vendorHash = "sha256-HAaoVYK6av085zSG0ZRpbmUgEA2UEt7CGWF/834e+z4=";
    }).goModules;
in
buildPerlPackage {
  pname = "Percona-Toolkit";

  inherit src version;

  outputs = [ "out" ];

  nativeBuildInputs = [
    git
    shortenPerlShebang
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

  postInstall = ''
    shortenPerlShebang $(grep -l "/bin/env perl" $out/bin/*)
  '';

  meta = {
    description = "Collection of advanced command-line tools to perform a variety of MySQL and system tasks";
    homepage = "https://www.percona.com/software/database-tools/percona-toolkit";
    changelog = "https://docs.percona.com/percona-toolkit/release_notes.html";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
