{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  coreutils,
  dosfstools,
  findutils,
  gawk,
  gnugrep,
  grub2_light,
  ncurses,
  ntfs3g,
  parted,
  p7zip,
  util-linux,
  wimlib,
  wget,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.2.4";
  pname = "woeusb";

  src = fetchFromGitHub {
    owner = "WoeUSB";
    repo = "WoeUSB";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HB1E7rP/U58dyL3j6YnhF5AOGAcHqmA/ZZ5JNBDibco=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  postPatch = ''
    # Emulate version smudge filter (see .gitattributes, .gitconfig).
    for file in sbin/woeusb share/man/man1/woeusb.1; do
      substituteInPlace "$file" \
        --replace-fail '@@WOEUSB_VERSION@@' '${finalAttrs.version}'
    done
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv sbin/woeusb $out/bin
    installManPage share/man/man1/woeusb.1

    wrapProgram "$out/bin/woeusb" \
      --set PATH '${
        lib.makeBinPath [
          coreutils
          dosfstools
          findutils
          gawk
          gnugrep
          grub2_light
          ncurses
          ntfs3g
          parted
          p7zip
          util-linux
          wget
          wimlib
        ]
      }'

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Create bootable USB disks from Windows ISO images";
    homepage = "https://github.com/WoeUSB/WoeUSB";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bjornfor ];
    platforms = lib.platforms.linux;
    mainProgram = "woeusb";
  };
})
