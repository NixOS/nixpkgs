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
  re-plistbuddy,
  alsa-lib,
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
  version = "0.16.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crmne";
    repo = "zapfast";
    tag = "v${version}";
    hash = "sha256-5tD4jw/pbofC4sZchyAHffoYHnjaHScwXY9tlQYe6QE=";
  };

  cargoHash = "sha256-CsODwMDeT0TQX9/+OmV1GJW0O/DNrdtpQiBfWsSNlyY=";

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/updates/macos.rs \
      --replace-fail \
      'Command::new("/usr/libexec/PlistBuddy")' \
      'Command::new("${lib.getExe' re-plistbuddy "PlistBuddy"}")'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ makeWrapper ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rcodesign
    icnsify
    re-plistbuddy
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      libGL
      libx11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  env.ZAPFAST_TEST_RTL_FONT = "${liberation_ttf}/share/fonts/truetype/LiberationSans-Regular.ttf";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=updates::macos::tests::helper_runs_from_a_whole_copy_of_the_bundle"
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
