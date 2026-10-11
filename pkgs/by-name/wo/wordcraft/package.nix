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
  pname = "wordcraft";
  version = "0.5.0";
  commit = "e4b7d155f15a7784197ba34eeea0b54490d70eb2";
  buildDate = "2026-10-10";

  craftFonts = fetchFromGitHub {
    owner = "storytold";
    repo = "craft-fonts";
    rev = "8dcdacd5153e64560d109541a47d806f26f048c0";
    hash = "sha256-4E9OrthE5z39xFXpvpwn4Fn6RH3wX2sF56rZZejZT+I=";
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
    "wordcraft"
    "-p"
    "wordcraft-cli"
  ];
in
rustPlatform.buildRustPackage {
  inherit pname version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "wordcraft";
    rev = "v${version}";
    hash = "sha256-yJk5hzvvjwJXJkZFc/dO+Llf70w7xZnoX7zI3ifIuoY=";
  };

  cargoHash = "sha256-OljEFWaPOT3nmWU/xVTcbn3ePAdEYkhG6/U4ysVG9Kc=";

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
      WORDCRAFT_BUILD_SHA = commit;
      WORDCRAFT_BUILD_DATE = buildDate;
    };

  postInstall = ''
    install -Dm644 packaging/linux/ai.storyteller.wordcraft.desktop $out/share/applications/ai.storyteller.wordcraft.desktop
    install -Dm644 packaging/linux/ai.storyteller.wordcraft.mime.xml $out/share/mime/packages/ai.storyteller.wordcraft.xml

    mkdir -p $out/share/metainfo
    sed -e "s/@VERSION@/${version}/g" -e "s/@DATE@/${buildDate}/g" \
      packaging/linux/ai.storyteller.wordcraft.metainfo.xml.in > $out/share/metainfo/ai.storyteller.wordcraft.metainfo.xml

    mkdir -p $out/share/icons
    cp -r assets/app-icon/hicolor $out/share/icons/

    mkdir -p $out/share/doc/wordcraft
    for f in README.md LICENSE LICENSE-MIT LICENSE-APACHE COPYRIGHT NOTICE ATTRIBUTION.md; do
      if [ -f "$f" ]; then
        install -Dm644 "$f" "$out/share/doc/wordcraft/$f"
      fi
    done
  ''
  + lib.optionalString withCraftFonts ''
    for lic in ${craftFonts}/fonts/*/OFL.txt; do
      if [ -f "$lic" ]; then
        fam=$(basename $(dirname "$lic"))
        install -Dm644 "$lic" "$out/share/doc/wordcraft/OFL-$fam.txt"
      fi
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/wordcraft \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          ${lib.optionalString defaultToXWayland "--unset WAYLAND_DISPLAY --unset WAYLAND_SOCKET"}

        wrapProgram $out/bin/wordcraft-cli \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}"

        makeWrapper $out/bin/.wordcraft-wrapped $out/bin/wordcraft-xwayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${
            lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""
          } \
          --unset WAYLAND_DISPLAY \
          --unset WAYLAND_SOCKET

        makeWrapper $out/bin/.wordcraft-wrapped $out/bin/wordcraft-wayland \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
          ${lib.optionalString (xwayland != null) "--prefix PATH : \"${lib.makeBinPath [ xwayland ]}\""}

        cat >> $out/share/applications/ai.storyteller.wordcraft.desktop <<EOF

    Actions=XWayland;Wayland;

    [Desktop Action XWayland]
    Name=Open under XWayland (Drag and Drop support)
    Exec=wordcraft-xwayland %F

    [Desktop Action Wayland]
    Name=Open under native Wayland
    Exec=wordcraft-wayland %F
    EOF
  '';

  meta = with lib; {
    description = "Clean-room word processor and document designer in pure Rust";
    homepage = "https://github.com/storytold/wordcraft";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ johnrizzo1 ];
    mainProgram = "wordcraft";
    platforms = platforms.unix;
  };
}
