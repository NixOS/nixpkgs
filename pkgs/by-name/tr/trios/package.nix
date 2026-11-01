{
  _7zz,
  _experimental-update-script-combinators,
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
  nix-update-script,
  procps,
  runCommand,
  starsectorPath ? null,
  webkitgtk_4_1,
  xdg-utils,
  yq-go,
  zlib,
}:

let
  # Upstream tags have no `v` prefix (1.7.0, not v1.7.0) and ship `-previewN`
  # prereleases alongside stable releases; the updateScript follows stable only.
  version = "1.7.0";

  # Native dependencies of the Linux embedder and its plugins. zlib, curl,
  # gtk3, webkitgtk and libx11 are needed by the plugin code (and zlib by
  # Sentry's bundled crashpad, whose CMake looks for ZLIB and friends).
  #
  # The JDK is not just a build tool: the `jni` plugin runs find_package(JNI)
  # and the resulting libdartjni.so has NEEDED libjvm.so with a RUNPATH into the
  # JDK, so it is part of the runtime closure. Substituting a JRE saves nothing
  # worth the surgery (openjdk 574 MiB vs openjdk-headless 570 MiB).
  nativeDeps = [
    curl
    gtk3
    jdk
    libx11
    webkitgtk_4_1
    zlib
  ];

  src = fetchFromGitHub {
    owner = "wispborne";
    repo = "TriOS";
    # No `v` prefix on upstream tags.
    tag = version;
    hash = "sha256-x1yY03Cc4b4nj252BAgqnZhsii637SiAeYS82rzYt+0=";
  };
in
flutter347.buildFlutterApplication {
  __structuredAttrs = true;
  strictDeps = true;

  # Without structured attrs the builder gets `pubspecLockFilePath` from
  # `passAsFile` and symlinks it to ./pubspec.lock in configurePhase; with them
  # that variable is never set, so the symlink target comes out empty and the
  # build dies. Point it at the same lock the build already evaluates.
  env.pubspecLockFilePath = "${./pubspec.lock.json}";

  pname = "trios";
  inherit version src;

  buildInputs = nativeDeps;

  # `flutter build linux` invokes CMake itself, so the cmake builder's setup
  # hook never gets to wire up the dependency search paths and FindZLIB fails.
  preBuild = ''
    export CMAKE_INCLUDE_PATH="${lib.makeSearchPathOutput "dev" "include" nativeDeps}"
    export CMAKE_LIBRARY_PATH="${lib.makeSearchPath "lib" nativeDeps}";
  '';

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  patches = [
    # Look for a system 7-Zip instead of the binary bundled under assets/.
    ./patches/0001-use-system-7zip.patch
    # Support a game installed in a read-only prefix: STARSECTOR_DIR selects it
    # and the mods directory follows the game's own XDG redirect.
    ./patches/0002-support-read-only-nix-install.patch
  ];

  postPatch = ''
    # Upstream commits prebuilt 7-Zip binaries for every platform. They are
    # unused here (see the first patch) and would otherwise ship in $out.
    # Removals are forgiving so an upstream rename cannot break the build.
    rm -vf \
      assets/linux/7zip/{x64,arm64}/7zzs \
      assets/macos/7zip/7zz \
      assets/windows/7zip/{7z.exe,7z.dll,7-zip.dll}
    rm -rfv assets/windows/7zip/Codecs
  '';

  # TriOS shells out to these at runtime: 7zz (patch 0001), xdg-open/xdg-mime
  # and update-desktop-database (open_filex, url_launcher, desktop entries),
  # `gio` and `ps` (game detection), and `java` for the fallback process
  # detector (JpsProcessDetector is constructed with the literal 'java').
  # Coreutils provides chmod/uname, which the system PATH already supplies.
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
    # Starsector is unfree, so it is deliberately not a dependency. Consumers
    # that have it can point TriOS straight at it, e.g.
    #     trios.override { starsectorPath = "${pkgs.starsector}/share/starsector"; }
    # Passing it through the expression rather than letting TriOS guess a path
    # means it is rebuilt whenever starsector changes instead of holding on to a
    # stale store path. Note this argument is intentionally *not* named
    # `starsector`: callPackage would fill it from the top-level package set and
    # silently add the game to every user's closure. This must stay on one line:
    # the builder joins its own arguments to this string with a backslash-newline,
    # so a newline here would start a second shell command.
    lib.optionalString (starsectorPath != null) " --set-default STARSECTOR_DIR ${starsectorPath}"
  }";

  postInstall = ''
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/trios.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=TriOS
    GenericName=Starsector mod manager
    Comment=Install, configure and manage Starsector mods
    Exec=TriOS %u
    Icon=trios
    # TriOS sets its GTK application id to this, so the DE can match the window
    # to the icon above instead of a generic one.
    StartupWMClass=org.wisp.trios
    Terminal=false
    Categories=Game;
    Keywords=starsector;mods;modmanager;
    MimeType=x-scheme-handler/starsector-mod;
    EOF

    install -Dm644 assets/images/telos_faction_crest.png \
      "$out/share/icons/hicolor/128x128/apps/trios.png"
  '';

  passthru = {
    pubspecSource =
      runCommand "trios-pubspec.lock.json"
        {
          inherit src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';

    updateScript = _experimental-update-script-combinators.sequence [

      (nix-update-script {
        # Tags carry no `v` prefix. Upstream marks every `-previewN` release as a
        # GitHub prerelease, which nix-update already skips; anchoring the
        # pattern to three components additionally pins the tag shape, so a tag
        # in some other format cannot be picked up.
        extraArgs = [ "--version-regex=^(\\d+\\.\\d+\\.\\d+)$" ];
      })

      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "trios.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
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
    changelog = "https://github.com/wispborne/TriOS/releases";
    license = lib.licenses.mkLicense {
      shortName = "trios-community-1.0";
      fullName = "TriOS Community License v1.0";
      url = "https://github.com/wispborne/TriOS/blob/${version}/LICENSE.txt";
      # Apache-2.0 plus extra conditions on "Extensive Use" (derivatives must
      # stay open and may not charge fees), so it is not DFSG-free.
      free = false;
      redistributable = true;
    };
    mainProgram = "TriOS";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # Two Java artifacts ship prebuilt upstream and are copied into the bundle
      # as-is: assets/common/JpsAtHome.jar has no source in the release at all,
      # and assets/common/TriOS-Mod/jars/TriOS-Companion-Mod.jar is built against
      # Starsector's own API jars, which are not redistributable. Everything else
      # is compiled from source.
      binaryBytecode
    ];
    maintainers = [ lib.maintainers.twstagg ];
  };
}
