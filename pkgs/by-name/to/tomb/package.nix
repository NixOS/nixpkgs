{
  acl,
  coreutils,
  cryptsetup,
  e2fsprogs,
  fetchFromGitHub,
  file,
  gawk,
  getent,
  gettext,
  gnugrep,
  gnupg,
  lib,
  libargon2,
  lsof,
  makeWrapper,
  nix-update-script,
  pinentry,
  stdenvNoCC,
  testers,
  util-linux,
  zsh,
}:

let
  runtimeDependencies = [
    acl # setfacl
    coreutils # shred
    cryptsetup
    e2fsprogs # resize2fs
    file
    gawk
    getent
    gettext
    gnugrep
    gnupg
    libargon2
    lsof
    pinentry
    util-linux
  ];

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tomb";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "tomb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z7LkCes0wg+1bZrNXXy4Lh5VwMotCULJQy5DmCisu+Q=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    pinentry
    zsh
  ];

  postPatch = ''
    # if not, it shows .tomb-wrapped when running
    substituteInPlace tomb \
      --replace-fail 'TOMBEXEC=$0' 'TOMBEXEC=tomb'

    # Fix version variable
    sed -i 's/VERSION=".*"/VERSION="${finalAttrs.version}"/' tomb
  '';

  installPhase = ''
    install -Dm755 tomb $out/bin/tomb
    install -Dm644 doc/tomb.1 $out/share/man/man1/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${lib.makeBinPath runtimeDependencies}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "tomb -v";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "File encryption on GNU/Linux";
    homepage = "https://dyne.org/tomb/";
    changelog = "https://github.com/dyne/tomb/blob/v${finalAttrs.version}/ChangeLog.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "tomb";
    maintainers = with lib.maintainers; [
      peterhoeg
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
})
