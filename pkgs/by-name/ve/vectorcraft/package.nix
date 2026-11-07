{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,
  xcbuild,
  rcodesign,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vectorcraft";
  version = "0.21.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "vectorcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jHdKEfQK+O4WnEkyRnXuQ22248H4YVbrpWfnYz1xSgs=";
  };

  cargoHash = "sha256-YXuVyRwq8dIT/KlBv/8Bkv1p+zJtPZC01b4pYUIpD8s=";

  cargoBuildFlags = [
    "--package=vectorcraft"
    "--package=vectorcraft-cli"
  ];

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  # The `vectorcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=vectorcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    rcodesign
  ];

  # [[patch.unused]] egui fork entries in Cargo.toml break cargo --offline in the sandbox.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/linux/ai.storyteller.vectorcraft.desktop \
        $out/share/applications/ai.storyteller.vectorcraft.desktop
      install -Dm644 packaging/linux/ai.storyteller.vectorcraft.mime.xml \
        $out/share/mime/packages/ai.storyteller.vectorcraft.xml
      mkdir -p $out/share/icons
      cp -R assets/app-icon/hicolor $out/share/icons/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
        APP="$out/Applications/VectorCraft.app"

      mkdir -p $APP/Contents/{MacOS,Resources}

      ln -s $out/bin/vectorcraft $APP/Contents/MacOS/VectorCraft

      cp $NIX_BUILD_TOP/source/assets/app-icon/vectorcraft.icns $APP/Contents/Resources/VectorCraft.icns
      cp $NIX_BUILD_TOP/source/NOTICE $APP/Contents/Resources/

      sed -e "s/@VERSION@/${finalAttrs.version}/g" -e "s/@SHORT_VERSION@/${finalAttrs.version}/g" \
        -e "s/@BUILD_SHA@/unknown}/g" \
        "$NIX_BUILD_TOP/source/packaging/macos/Info.plist.in" >"$APP/Contents/Info.plist"
      plutil -lint "$APP/Contents/Info.plist"

      printf 'APPL????' >"$APP/Contents/PkgInfo"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP/Contents/MacOS/VectorCraft"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP"
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/vectorcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector illustration, a native Illustrator-style editor for SVG and PDF";
    homepage = "https://github.com/storytold/vectorcraft";
    changelog = "https://github.com/storytold/vectorcraft/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "vectorcraft";
    platforms = rustc.meta.platforms;
  };
})
