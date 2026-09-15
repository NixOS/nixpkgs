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
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "sha256-bdEc+vaWxEN5jzd1bcScBj1QV7Oz7Xn3XWeW6TvkE/E=";

    # needed for build script
    leaveDotGit = true;
  };

  goDeps =
    (buildGoModule {
      pname = "Percona-Toolkit go-bindings";
      inherit src version;

      vendorHash = "sha256-+MToOAyY8UiNKWSMR4Mhw5foJPBoturoxWhX84tjfro=";
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
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ izorkin ];
  };
}
