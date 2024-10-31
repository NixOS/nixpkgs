{
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
  util-linux,
  zsh,
}:

stdenvNoCC.mkDerivation rec {
  pname = "tomb";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "dyne";
    repo = "Tomb";
    rev = "refs/tags/v${version}";
    hash = "sha256-H9etbodTKxROJAITbViQQ6tkEr9rKNITTHfsGGQbyR0=";
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
  '';

  installPhase = ''
    install -Dm755 tomb $out/bin/tomb
    install -Dm644 doc/tomb.1 $out/share/man/man1/tomb.1

    wrapProgram $out/bin/tomb \
      --prefix PATH : $out/bin:${
        lib.makeBinPath [
          coreutils
          cryptsetup
          e2fsprogs
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
        ]
      }
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "File encryption on GNU/Linux";
    homepage = "https://www.dyne.org/software/tomb/";
    changelog = "https://github.com/dyne/Tomb/blob/v${version}/ChangeLog.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "tomb";
    maintainers = with lib.maintainers; [
      peterhoeg
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
}
