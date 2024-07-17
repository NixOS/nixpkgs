{ lib
, fetchFromGitHub
, buildPerlPackage
, shortenPerlShebang
, DBDmysql
, DBI
, IOSocketSSL
, TermReadKey
, go
, buildGoModule
, git
}:

let
  version = "3.6.0"; # Adjust the version as needed

  src = fetchFromGitHub {
    owner = "percona";
    repo = "percona-toolkit";
    rev = "v${version}";
    sha256 = "sha256-NtyUm6swKru2VkBD+WzRN99oC3dGVguZWgFZxcOUv7E";

    # needed for build script
    leaveDotGit = true;
  };

  goDeps = (buildGoModule rec {
    pname = "Percona-Toolkit go-bindings";
    inherit src version;


    vendorHash = "sha256-uOKccpRuVjtbBW1stTZtUdD1DsUpD9i87wZ4iJrFfUw"; # Nix will automatically fetch and verify dependencies

    buildPhase = ''
      # skip me
    '';
  }).goModules;
in
buildPerlPackage rec {
  pname = "Percona-Toolkit";

  inherit src version;

  outputs = [ "out" ];

  nativeBuildInputs = [ shortenPerlShebang ];

  buildInputs = [
    DBDmysql
    go
    DBI
    IOSocketSSL
    TermReadKey
    git
  ];


  # workaround for
  postPatch = ''
    cp -r --reflink=auto ${goDeps} vendor
  '';

  preBuild = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
      shortenPerlShebang $(grep -l " /bin/env
    perl " $out/bin/*)
  '';

  meta = {
    description = "
    Collection
    of
    advanced
    command-line
    tools
    to
    perform
    a
    variety
    of
    MySQL
    and
    system
    tasks ";
    homepage = " https://www.percona.com/software/database-tools/percona-toolkit ";
    changelog = " https://docs.percona.com/percona-toolkit/release_notes.html ";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [
      izorkin
      michaelglass
    ];
  };
}
