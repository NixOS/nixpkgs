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
  version = "0.1.24";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "y0sif";
    repo = "whisrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X0bU3UJYXrwWMVIOrzMENl2VsVHcDYcHCKkQWWvTY6s=";
  };

  cargoHash = "sha256-z4oBV0VdzszGIWc6O0om2lvKXuDOWRgbC8YbEBFsj6o=";

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
