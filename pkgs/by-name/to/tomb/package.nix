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
  makeBinaryWrapper,
  nix-update-script,
  pinentry,
  stdenvNoCC,
  util-linuxMinimal,
  versionCheckHook,
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
    util-linuxMinimal
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

  nativeBuildInputs = [ makeBinaryWrapper ];

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
    runHook preInstall

    install -D -m755 -t $out/bin tomb
    install -D -m644 -t $out/share/man/man1/ doc/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${lib.makeBinPath runtimeDependencies}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru = {
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
