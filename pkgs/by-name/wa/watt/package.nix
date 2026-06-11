{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "watt";
  version = "1.2.0";
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "notashelf";
    repo = "watt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mb7z1NHhS5DtFNzi/H/XQR5RfhYY5ELxJg8DFMWtzmU=";
  };
  cargoBuildFlags = [
    "-p watt"
    "-p xtask"
  ];
  cargoHash = "sha256-2eHr88gMfiwimpcPa/ZQ08C2YalO91fH6BSvcyLNcso=";
  enableParallelBuilding = true;
  useNextest = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # xtask doesn't support passing --target
  # but nix hooks expect the folder structure from when it's set
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.cargoShortTarget;

  postInstall = ''
    # Install required files with the 'dist' task
    $out/bin/xtask dist --completions-dir $out/share/completions

    # Avoid populating PATH with an 'xtask' cmd
    rm $out/bin/xtask

    install -Dm644 dbus/net.hadess.PowerProfiles.conf \
      $out/share/dbus-1/system.d/net.hadess.PowerProfiles.conf
  '';

  meta = {
    description = "Modern CPU frequency and power management utility for Linux ";
    homepage = "https://github.com/NotAShelf/watt";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ Soliprem ];
    mainProgram = "watt";
    platforms = lib.platforms.linux;
  };
})
