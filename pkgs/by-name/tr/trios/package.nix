{
  _7zz,
  _experimental-update-script-combinators,
  copyDesktopItems,
  curl,
  dart,
  desktop-file-utils,
  fetchFromGitHub,
  flutter347,
  glib,
  gtk3,
  jdk,
  lib,
  libx11,
  makeDesktopItem,
  nix-update-script,
  procps,
  runCommand,
  starsectorPath ? null,
  webkitgtk_4_1,
  xdg-utils,
  yq-go,
  zlib,
}:

flutter347.buildFlutterApplication (finalAttrs: {
  pname = "trios";

  # Upstream tags carry no `v` prefix; `-previewN` tags are GitHub prereleases.
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "wispborne";
    repo = "TriOS";
    tag = finalAttrs.version;
    hash = "sha256-x1yY03Cc4b4nj252BAgqnZhsii637SiAeYS82rzYt+0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Under __structuredAttrs the builder never gets pubspecLockFilePath from
  # passAsFile, so the ./pubspec.lock symlink it makes comes out empty.
  env.pubspecLockFilePath = "${finalAttrs.passthru.pubspecLockFile}";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  # Native dependencies of the Linux embedder and its plugins (crashpad's CMake
  # also looks for ZLIB). The JDK is runtime, not just build: libdartjni.so from
  # the `jni` plugin has NEEDED libjvm.so with a RUNPATH into it, and a JRE saves
  # 4 MiB, not worth the surgery.
  buildInputs = [
    curl
    gtk3
    jdk
    libx11
    webkitgtk_4_1
    zlib
  ];

  # `flutter build linux` invokes CMake itself, so the cmake builder's setup hook
  # never wires up the dependency search paths and FindZLIB fails.
  preBuild = ''
    export CMAKE_INCLUDE_PATH="${lib.makeSearchPathOutput "dev" "include" finalAttrs.buildInputs}"
    export CMAKE_LIBRARY_PATH="${lib.makeSearchPath "lib" finalAttrs.buildInputs}";
  '';

  # pub2nix needs the dependency graph at eval time and Nix cannot read inside
  # the tarball then, so the lock has to be in-tree. It is generated, not edited:
  # see passthru.pubspecSource and the update script below.
  pubspecLock = lib.importJSON finalAttrs.passthru.pubspecLockFile;
  gitHashes = lib.importJSON ./git-hashes.json;

  patches = [
    # Look for a system 7-Zip instead of the binary bundled under assets/.
    ./patches/0001-use-system-7zip.patch
    # Support a game installed in a read-only prefix: STARSECTOR_DIR selects it
    # and the mods directory follows the game's own XDG redirect.
    ./patches/0002-support-read-only-nix-install.patch
  ];

  postPatch = ''
    # Upstream's vendored 7-Zip binaries, unused here (see patch 0001). -f so an
    # upstream rename cannot break the build.
    rm -vf \
      assets/linux/7zip/{x64,arm64}/7zzs \
      assets/macos/7zip/7zz \
      assets/windows/7zip/{7z.exe,7z.dll,7-zip.dll}
    rm -rfv assets/windows/7zip/Codecs
  '';

  # Tools TriOS shells out to at runtime: 7zz (patch 0001), xdg-utils and
  # update-desktop-database (url_launcher, open_filex), gio and ps (game
  # detection), and java (JpsProcessDetector is built with the literal 'java').
  #
  # Starsector is unfree so it is not a dependency; consumers opt in with
  #     trios.override { starsectorPath = "${pkgs.starsector}/share/starsector"; }
  # which rebuilds when starsector changes instead of pinning a store path. The
  # argument is deliberately not named `starsector`: callPackage would fill it
  # from the package set and pull the game into every closure.
  #
  # Keep this on one line: the dart fixup hook evals it, so a newline starts a
  # second shell command.
  extraWrapProgramArgs = "--prefix PATH : ${
    lib.makeBinPath [
      _7zz
      desktop-file-utils
      glib
      jdk
      procps
      xdg-utils
    ]
  } --set-default TRIOS_7ZZ ${lib.getExe _7zz}${
    lib.optionalString (starsectorPath != null) " --set-default STARSECTOR_DIR ${starsectorPath}"
  }";

  desktopItems = [
    (makeDesktopItem {
      name = "trios";
      exec = "TriOS %u";
      icon = "trios";
      desktopName = "TriOS";
      genericName = "Starsector mod manager";
      comment = "Install, configure and manage Starsector mods";
      categories = [ "Game" ];
      keywords = [
        "starsector"
        "mods"
        "modmanager"
      ];
      mimeTypes = [ "x-scheme-handler/starsector-mod" ];
      # TriOS' GTK application id, so the DE matches the window to the icon.
      startupWMClass = "org.wisp.trios";
      terminal = false;
    })
  ];

  postInstall = ''
    install -Dm644 assets/images/telos_faction_crest.png \
      "$out/share/icons/hicolor/128x128/apps/trios.png"
  '';

  passthru = {
    pubspecLockFile = ./pubspec.lock.json;
    # Upstream's pubspec.lock rendered as JSON; the update script writes this
    # output over the committed file, so they cannot drift.
    pubspecSource =
      runCommand "trios-pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        # Anchored to three components to pin the tag shape.
        extraArgs = [ "--version-regex=^(\\d+\\.\\d+\\.\\d+)$" ];
      })

      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "trios.pubspecSource" finalAttrs.passthru.pubspecLockFile)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          finalAttrs.passthru.pubspecLockFile
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "Mod manager for the game Starsector";
    homepage = "https://github.com/wispborne/TriOS";
    changelog = "https://github.com/wispborne/TriOS/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mkLicense {
      shortName = "trios-community-1.0";
      fullName = "TriOS Community License v1.0";
      url = "https://github.com/wispborne/TriOS/blob/${finalAttrs.version}/LICENSE.txt";
      # Apache-2.0 plus "Extensive Use" conditions (derivatives stay open and
      # free), so not DFSG-free. Building a package is not Extensive Use.
      free = false;
      redistributable = true;
    };
    mainProgram = "TriOS";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # JpsAtHome.jar and TriOS-Companion-Mod.jar ship prebuilt. Both are TriOS'
      # own work (the licence covers binaries) and the companion jar holds only
      # wisp/trios classes, but neither can be rebuilt here: the mod compiles
      # against Starsector's API jars plus the third-party Console Commands jar.
      binaryBytecode
    ];
    maintainers = [ lib.maintainers.twstagg ];
  };
})
