{
  lib,
  rustPlatform,
  fetchFromGitHub,

  cmake,
  installShellFiles,
  llvmPackages,
  makeWrapper,
  pkg-config,

  alsa-lib,
  libxkbcommon,
  wl-clipboard,

  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "whisrs";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "y0sif";
    repo = "whisrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQsKX0mj9MRW06kGTVRw4CsuY7+CNA/MfdmF88dJAlE=";
  };

  cargoHash = "sha256-ZckDvQFoQ6JchmBcpfto/qQ2s1m4pXspal3OXY/uVAs=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    makeWrapper
    llvmPackages.clang
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    libxkbcommon
  ];

  patches = [ ./nixos-uinput-setup.patch ];

  # contrib/99-whisrs.rules is deliberately not installed: it grants /dev/uinput
  # to the `input` group and would override the `uinput` group set by NixOS's
  # hardware.uinput.enable. Users should enable that option instead.
  postInstall = ''
    substituteInPlace contrib/whisrs.service \
      --replace-fail 'ExecStart=whisrsd' "ExecStart=$out/bin/whisrsd"
    install -Dm644 src/overlay/font/OFL.txt $out/share/licenses/whisrs/OFL.txt
    installManPage contrib/whisrs.1 contrib/whisrsd.1
    install -Dm644 contrib/whisrs.service -t $out/lib/systemd/user
  '';

  postFixup = ''
    for program in whisrs whisrsd; do
      wrapProgram $out/bin/$program \
        --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
    done
  '';

  versionCheckProgram = "${placeholder "out"}/bin/whisrsd";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Voice-to-text dictation daemon that types transcriptions into the focused window";
    homepage = "https://github.com/y0sif/whisrs";
    license = with lib.licenses; [
      mit
      ofl
    ];
    mainProgram = "whisrs";
    maintainers = with lib.maintainers; [ otavio ];
    platforms = lib.platforms.linux;
  };
})
