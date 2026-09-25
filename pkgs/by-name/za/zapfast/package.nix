{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  makeWrapper,
  nix-update-script,
  alsa-lib,
  libGL,
  libx11,
  libxkbcommon,
  wayland,
  libxcursor,
  libxi,
  libxrandr,
  liberation_ttf,
}:

let
  runtimeLibraries = [
    libxkbcommon
    wayland
    libGL
    libx11
    libxcursor
    libxi
    libxrandr
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "zapfast";
  version = "0.16.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "zapfast";
    tag = "v${version}";
    hash = "sha256-5tD4jw/pbofC4sZchyAHffoYHnjaHScwXY9tlQYe6QE=";
  };

  cargoHash = "sha256-CsODwMDeT0TQX9/+OmV1GJW0O/DNrdtpQiBfWsSNlyY=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libGL
    libx11
  ];

  env.ZAPFAST_TEST_RTL_FONT = "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf";

  postFixup = ''
    wrapProgram $out/bin/zapfast \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibraries}
  '';

  postInstall = ''
    install -Dm644 packaging/applications/zapfast.desktop \
      $out/share/applications/zapfast.desktop

    install -Dm644 packaging/icons/zapfast.svg \
      $out/share/icons/hicolor/scalable/apps/zapfast.svg
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast native WhatsApp client";
    homepage = "https://zapfast.rocks";
    changelog = "https://github.com/crmne/zapfast/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "zapfast";
    platforms = lib.platforms.linux;
  };
}
