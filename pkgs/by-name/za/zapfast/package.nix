{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  makeWrapper,
  icnsify,
  nix-update-script,
  rcodesign,
  alsa-lib,
  pipewire,
  libGL,
  libx11,
  libxkbcommon,
  wayland,
  libxcursor,
  libxi,
  libxrandr,
  liberation_ttf,
  apple-sdk_15,
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
  version = "0.20.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "zapfast";
    tag = "v${version}";
    hash = "sha256-kkj9oikkNAxMlLC4zMJNPUqB/HQ47h+mmhowOBJoD1E=";
  };

  cargoHash = "sha256-6jGLa8dbGt6wECk7F0oBfho40n8lTBlbSdG9S2YI7NY=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rcodesign
    icnsify
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      pipewire
      libGL
      libx11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  env.ZAPFAST_TEST_RTL_FONT = "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf";

  cargoTestFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--lib"
    "--bin"
    "zapfast"
    # skips "--test" "macos_menu", AppKit menus test fails in build sandbox
  ];

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgram $out/bin/zapfast \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibraries}
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      rcodesign sign "$out/Applications/ZapFast.app"
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/applications/zapfast.desktop \
        $out/share/applications/zapfast.desktop

      install -Dm644 packaging/icons/zapfast.svg \
        $out/share/icons/hicolor/scalable/apps/zapfast.svg

      install -Dm644 packaging/flatpak/rocks.zapfast.ZapFast.metainfo.xml \
        $out/share/metainfo/rocks.zapfast.ZapFast.metainfo.xml
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      app="$out/Applications/ZapFast.app/Contents"
      mkdir -p "$app/MacOS" "$app/Resources"
      cp "$out/bin/zapfast" "$app/MacOS/zapfast"
      icnsify packaging/macos/icon-1024.png -o "$app/Resources/zapfast.icns"
      substitute packaging/macos/Info.plist "$app/Info.plist" \
        --replace-fail __VERSION__ "${version}"
    '';

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast native WhatsApp client";
    homepage = "https://zapfast.rocks";
    changelog = "https://github.com/crmne/zapfast/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "zapfast";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
