{
  lib,
  stdenv,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  writeText,
  autoPatchelfHook,
  patchelfUnstable, # have to use patchelfUnstable to support --no-clobber-old-sections
  wrapGAppsHook3,
  callPackage,

  atk,
  cairo,
  dbus,
  dbus-glib,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libxcb,
  libX11,
  libXext,
  libXrender,
  libXt,
  libXtst,
  libgbm,
  pango,
  pciutils,
  zlib,

  libnotifySupport ? stdenv.hostPlatform.isLinux,
  libnotify,

  waylandSupport ? stdenv.hostPlatform.isLinux,
  libxkbcommon,
  libdrm,
  libGL,

  mediaSupport ? true,
  ffmpeg_7,

  audioSupport ? mediaSupport,

  pipewireSupport ? audioSupport,
  pipewire,

  pulseaudioSupport ? audioSupport,
  libpulseaudio,
  apulse,
  alsa-lib,

  libvaSupport ? mediaSupport,
  libva,

  # Whether to use IPC for communicating with Tor
  useIPCTorService ? false,
  # Whether to disable multiprocess support
  disableContentSandbox ? false,

  # Extra preferences
  extraPrefs ? "",
}:

let
  libPath = lib.makeLibraryPath (
    [
      alsa-lib
      atk
      cairo
      dbus
      dbus-glib
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libxcb
      libX11
      libXext
      libXrender
      libXt
      libXtst
      libgbm
      pango
      pciutils
      stdenv.cc.cc
      stdenv.cc.libc
      zlib
    ]
    ++ lib.optionals libnotifySupport [ libnotify ]
    ++ lib.optionals waylandSupport [
      libxkbcommon
      libdrm
      libGL
    ]
    ++ lib.optionals pipewireSupport [ pipewire ]
    ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals libvaSupport [ libva ]
    ++ lib.optionals mediaSupport [ ffmpeg_7 ]
  );

  version = "15.0.2";

  sources = {
    x86_64-linux = fetchurl {
      urls = [
        "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.eff.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
        "https://tor.calyxinstitute.org/dist/torbrowser/${version}/tor-browser-linux-x86_64-${version}.tar.xz"
      ];
      hash = "sha256-GtO7u9KhZgIbdTJqMTQ2ZabA6PKrwW0ogxYJvmkVfV8=";
    };

    i686-linux = fetchurl {
      urls = [
        "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://tor.eff.org/dist/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
        "https://tor.calyxinstitute.org/dist/torbrowser/${version}/tor-browser-linux-i686-${version}.tar.xz"
      ];
      hash = "sha256-SHJQvNqC4Ulyg81rcp6sTG0Wwv9fHqWYQPpPBsPgwss=";
    };
  };

  distributionIni = writeText "distribution.ini" (
    lib.generators.toINI { } {
      # Some light branding indicating this build uses our distro preferences
      Global = {
        id = "nixos";
        version = "1.0";
        about = "Tor Browser for NixOS";
      };
    }
  );

  policiesJson = writeText "policies.json" (
    builtins.toJSON {
      policies.DisableAppUpdate = true;
    }
  );
in
stdenv.mkDerivation rec {
  pname = "tor-browser";
  inherit version;

  src =
    sources.${stdenv.hostPlatform.system}
      or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoPatchelfHook
    patchelfUnstable
    copyDesktopItems
    makeWrapper
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk3
    alsa-lib
    dbus-glib
    libXtst
  ];

  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];

  desktopItems = [
    (makeDesktopItem {
      name = "torbrowser";
      exec = "tor-browser %U";
      icon = "tor-browser";
      desktopName = "Tor Browser";
      genericName = "Web Browser";
      comment = meta.description;
      categories = [
        "Network"
        "WebBrowser"
        "Security"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "application/vnd.mozilla.xul+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      startupWMClass = "Tor Browser";
    })
  ];

  buildPhase = ''
    runHook preBuild

    # For convenience ...
    TBB_IN_STORE=$out/share/tor-browser

    # Unpack & enter
    mkdir -p "$TBB_IN_STORE"
    tar xf "$src" -C "$TBB_IN_STORE" --strip-components=2
    pushd "$TBB_IN_STORE"

    # Set ELF interpreter
    autoPatchelf firefox.real TorBrowser/Tor

    # firefox is a wrapper that checks for a more recent libstdc++ & appends it to the ld path
    mv firefox.real firefox

    # store state at `~/.tor browser` instead of relative to executable
    touch "$TBB_IN_STORE/system-install"

    # The final libPath.  Note, we could split this into firefoxLibPath
    # and torLibPath for accuracy, but this is more convenient ...
    libPath=${libPath}:$TBB_IN_STORE:$TBB_IN_STORE/TorBrowser/Tor

    # apulse uses a non-standard library path.  For now special-case it.
    ${lib.optionalString (audioSupport && !pulseaudioSupport) ''
      libPath=${apulse}/lib/apulse:$libPath
    ''}

    # Fixup paths to pluggable transports.
    substituteInPlace TorBrowser/Data/Tor/torrc-defaults \
      --replace-fail './TorBrowser' "$TBB_IN_STORE/TorBrowser"

    # Prepare for autoconfig.
    #
    # See https://developer.mozilla.org/en-US/Firefox/Enterprise_deployment
    cat >defaults/pref/autoconfig.js <<EOF
    //
    pref("general.config.filename", "mozilla.cfg");
    pref("general.config.obscure_value", 0);
    EOF

    # Hard-coded Firefox preferences.
    cat >mozilla.cfg <<EOF
    // First line must be a comment

    // Reset pref that captures store paths.
    clearPref("extensions.xpiState");

    // Stop obnoxious first-run redirection.
    lockPref("noscript.firstRunRedirection", false);

    // User should never change these.  Locking prevents these
    // values from being written to prefs.js, avoiding Store
    // path capture.
    lockPref("extensions.torlauncher.torrc-defaults_path", "$TBB_IN_STORE/TorBrowser/Data/Tor/torrc-defaults");
    lockPref("extensions.torlauncher.tor_path", "$TBB_IN_STORE/TorBrowser/Tor/tor");

    // Optionally use IPC for communicating with Tor
    //
    // Sockets are created at \$XDG_RUNTIME_DIR/Tor/{socks,control}.socket
    ${lib.optionalString useIPCTorService ''
      lockPref("extensions.torlauncher.control_port_use_ipc", true);
      lockPref("extensions.torlauncher.socks_port_use_ipc", true);
    ''}

    // Optionally disable multiprocess support.  We always set this to ensure that
    // toggling the pref takes effect.
    lockPref("browser.tabs.remote.autostart.2", ${if disableContentSandbox then "false" else "true"});

    // Allow sandbox access to sound devices if using ALSA directly
    ${
      if (audioSupport && !pulseaudioSupport) then
        ''
          pref("security.sandbox.content.write_path_whitelist", "/dev/snd/");
        ''
      else
        ''
          clearPref("security.sandbox.content.write_path_whitelist");
        ''
    }

    ${lib.optionalString (extraPrefs != "") ''
      ${extraPrefs}
    ''}
    EOF

    # FONTCONFIG_FILE is required to make fontconfig read the TBB
    # fonts.conf; upstream uses FONTCONFIG_PATH, but FC_DEBUG=1024
    # indicates the system fonts.conf being used instead.
    FONTCONFIG_FILE=$TBB_IN_STORE/fonts/fonts.conf
    substituteInPlace "$FONTCONFIG_FILE" \
      --replace-fail '<dir prefix="cwd">fonts</dir>' "<dir>$TBB_IN_STORE/fonts</dir>"

    # Hard-code paths to geoip data files.  TBB resolves the geoip files
    # relative to torrc-defaults_path but if we do not hard-code them
    # here, these paths end up being written to the torrc in the user's
    # state dir.
    cat >>TorBrowser/Data/Tor/torrc-defaults <<EOF
    GeoIPFile $TBB_IN_STORE/TorBrowser/Data/Tor/geoip
    GeoIPv6File $TBB_IN_STORE/TorBrowser/Data/Tor/geoip6
    EOF

    mkdir -p $out/bin

    makeWrapper "$TBB_IN_STORE/firefox" "$out/bin/tor-browser" \
      --prefix LD_LIBRARY_PATH : "$libPath" \
      --set FONTCONFIG_FILE "$FONTCONFIG_FILE" \
      --set-default MOZ_ENABLE_WAYLAND 1

    # Easier access to docs
    mkdir -p $out/share/doc
    ln -s $TBB_IN_STORE/TorBrowser/Docs $out/share/doc/tor-browser

    # Install icons
    for i in 16 32 48 64 128; do
      mkdir -p $out/share/icons/hicolor/''${i}x''${i}/apps/
      ln -s $out/share/tor-browser/browser/chrome/icons/default/default$i.png $out/share/icons/hicolor/''${i}x''${i}/apps/tor-browser.png
    done

    # Check installed apps
    echo "Checking bundled Tor ..."
    LD_LIBRARY_PATH=$libPath $TBB_IN_STORE/TorBrowser/Tor/tor --version >/dev/null

    echo "Checking tor-browser wrapper ..."
    $out/bin/tor-browser --version >/dev/null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install distribution customizations
    install -Dvm644 ${distributionIni} $out/share/tor-browser/distribution/distribution.ini
    install -Dvm644 ${policiesJson} $out/share/tor-browser/distribution/policies.json

    runHook postInstall
  '';

  passthru = {
    inherit sources;
    updateScript = callPackage ./update.nix {
      inherit pname version meta;
    };
  };

  meta = {
    description = "Privacy-focused browser routing traffic through the Tor network";
    mainProgram = "tor-browser";
    homepage = "https://www.torproject.org/";
    changelog = "https://gitweb.torproject.org/builders/tor-browser-build.git/plain/projects/tor-browser/Bundle-Data/Docs/ChangeLog.txt?h=maint-${version}";
    platforms = lib.attrNames sources;
    maintainers = with lib.maintainers; [
      c4patino
      felschr
      hax404
      joachifm
      panicgh
    ];
    # MPL2.0+, GPL+, &c.  While it's not entirely clear whether
    # the compound is "libre" in a strict sense (some components place certain
    # restrictions on redistribution), it's free enough for our purposes.
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
      lgpl3Plus
      free
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
