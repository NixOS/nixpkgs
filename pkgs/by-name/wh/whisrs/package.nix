{
  lib,
  rustPlatform,
  fetchFromGitHub,

  cmake,
  installShellFiles,
  llvmPackages,
  pkg-config,

  alsa-lib,
  libxkbcommon,

  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "whisrs";
  version = "0.1.27";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "y0sif";
    repo = "whisrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sBBxtq1YXKbYoXtaEfoUWLJjfVgGKrfnXbPXYE798tQ=";
  };

  cargoHash = "sha256-Us7WkzNUPYCwv+UfdEwkZe9Xdk9ejwnEJ8t8ZPEWujA=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    llvmPackages.clang
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    alsa-lib
    libxkbcommon
  ];

  # contrib/99-whisrs.rules is deliberately not installed: it grants /dev/uinput
  # to the `input` group and would override the `uinput` group set by NixOS's
  # hardware.uinput.enable. Users should enable that option instead.
  postInstall = ''
    installManPage contrib/whisrs.1 contrib/whisrsd.1
    install -Dm644 contrib/whisrs.service -t $out/lib/systemd/user
  '';

  versionCheckProgram = "${placeholder "out"}/bin/whisrsd";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Voice-to-text dictation daemon that types transcriptions into the focused window";
    homepage = "https://github.com/y0sif/whisrs";
    license = lib.licenses.mit;
    mainProgram = "whisrs";
    maintainers = with lib.maintainers; [ otavio ];
    platforms = lib.platforms.linux;
  };
})
