{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-bongocat";
  version = "1.2.5";
  src = fetchFromGitHub {
    owner = "saatvik333";
    repo = "wayland-bongocat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VkBuqmen6s/LDFu84skQ3wOpIeURZ5e93lvAiEdny70=";
  };

  # Package dependencies
  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
  ];

  # Build phases
  # Ensure that the Makefile has the correct directory with the Wayland protocols
  preBuild = ''
    export WAYLAND_PROTOCOLS_DIR="${wayland-protocols}/share/wayland-protocols"
  '';

  makeFlags = [ "release" ];
  installPhase = ''
    runHook preInstall

    # Install binaries
    install -Dm755 build/bongocat $out/bin/${finalAttrs.meta.mainProgram}
    install -Dm755 scripts/find_input_devices.sh $out/bin/bongocat-find-devices

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Package information
  meta = {
    description = "Delightful Wayland overlay that displays an animated bongo cat reacting to keyboard input";
    homepage = "https://github.com/saatvik333/wayland-bongocat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ voxi0 ];
    mainProgram = "bongocat";
    platforms = lib.platforms.linux;
  };
})
