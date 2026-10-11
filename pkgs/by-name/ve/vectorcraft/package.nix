{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  libxcb,
  libxkbcommon,
  wayland,
  wayland-scanner ? null,
  vulkan-loader,
  autoAddDriverRunpath ? null,
  apple-sdk ? null,
  withCraftFonts ? true,
  defaultToXWayland ? false,
  xwayland ? null,
}:

let
  pname = "vectorcraft";
  version = "0.7.0";
  commit = "af7a5239be4636035abf7ecf79e6b0b8d274c7c3";
  buildDate = "2026-10-08";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "abb83316d96aa59c1cf64784289e378fe9fa5695";
    hash = "sha256-e+6HpOYoAFTh6mNfGBBw2njnBzcE8W8+Jybv1+dKOCA=";
  };

  runtimeLibs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    vulkan-loader
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
    libxcb
    fontconfig
  ];

  workspacePackages = [
    "-p"
    "vectorcraft"
    "-p"
    "vectorcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "vectorcraft";
    rev = "v${version}";
    hash = "sha256-W76TxJHWIfLwFmocahH8MCaWARGJYS6q3YLJNoWb0AI=";
  };

  cargoHash = "sha256-mCTuARKTk/8Dhiefool5VAUlYEM+tSu4tkUTnmlKaLY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    lib.optional (wayland-scanner != null) wayland-scanner
    ++ lib.optional (autoAddDriverRunpath != null) autoAddDriverRunpath
  );

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux runtimeLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk
    ];

  cargoBuildFlags = workspacePackages;
  cargoTestFlags = workspacePackages;

  env =
    lib.optionalAttrs withCraftFonts {
      CRAFT_FONTS_DIR = "${craftFonts}";
      CRAFT_FONTS_REQUIRED = "1";
    }
    // {
      VECTORCRAFT_BUILD_SHA = commit;
      VECTORCRAFT_BUILD_DATE = buildDate;
    };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.vectorcraft.desktop $out/share/applications/ai.storyteller.vectorcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.vectorcraft.mime.xml $out/share/mime/packages/ai.storyteller.vectorcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.vectorcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.vectorcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/vectorcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE NOTICE COPYRIGHT; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/vectorcraft/$f"
      fi
    done
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/vectorcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/vectorcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/vectorcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.vectorcraft-wrapped $out/bin/vectorcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.vectorcraft-wrapped $out/bin/vectorcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.vectorcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland
    Exec=vectorcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=vectorcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Open-source, clean-room reimplementation of Adobe Illustrator in pure Rust";
    homepage = "https://github.com/storytold/vectorcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "vectorcraft";
    platforms = platforms.unix;
  };
}
