{
  lib,
  stdenv,
  callPackage,
  chromium,
  coreutils,
  makeWrapper,
  xdg-utils,
  glib,
  gtk3,
  gtk4,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  libva,
  pipewire,
  wayland,
  libkrb5,
  runCommand,
  widevine-cdm,

  proprietaryCodecs ? true,
  enableWideVine ? false,
  commandLineArgs ? "",
}:

let
  browser = callPackage ./browser.nix {
    chromium = chromium.override { inherit proprietaryCodecs; };
  };

  browserWV =
    if enableWideVine then
      runCommand (browser.name + "-wv") { } ''
        mkdir -p $out
        cp -a ${browser}/* $out/
        chmod u+w $out/libexec/trivalent
        cp -a ${widevine-cdm}/share/google/chrome/WidevineCdm $out/libexec/trivalent/
      ''
    else
      browser;
in
stdenv.mkDerivation {
  pname = "trivalent";
  inherit (browser) version;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas
    glib
    gtk3
    gtk4

    # needed for XDG_ICON_DIRS
    adwaita-icon-theme

    # needed for kerberos at runtime
    libkrb5
  ];

  buildCommand =
    let
      browserBinary = "${browserWV}/libexec/trivalent/trivalent";
      libPath = lib.makeLibraryPath [
        libva
        pipewire
        wayland
        gtk3
        gtk4
        libkrb5
      ];

      wrapperArgs = [
        # Refuse to run as root (upstream launcher behavior)
        "--run 'if [ \"$EUID\" -eq 0 ]; then echo \"Trivalent must not be run as root.\" >&2; exit 1; fi'"

        # Make generated desktop shortcuts have a valid executable name.
        "--set CHROME_WRAPPER trivalent"
        "--suffix LD_LIBRARY_PATH : ${libPath}"

        # https://github.com/NixOS/nixpkgs/issues/352131
        "--unset LD_PRELOAD"
        "--unset LD_AUDIT"
        "--unset LD_PROFILE"

        # Avoid glycin issues (upstream launcher behavior)
        "--set GDK_DISABLE icon-nodes"

        "--prefix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\""
      ]
      # Hardware CFI (IBT + shadow stack), as the upstream launcher sets
      ++ lib.optional stdenv.hostPlatform.isx86_64 "--set GLIBC_TUNABLES glibc.cpu.x86_ibt=on:glibc.cpu.x86_shstk=permissive"
      # Fallback for xdg-open and friends
      ++ lib.optional (!xdg-utils.meta.broken) "--suffix PATH : ${xdg-utils}/bin"
      ++ [
        # std{in,out,err} are shared with untrusted child processes (http://crbug.com/376567)
        "--run 'exec < /dev/null'"
        "--run 'exec > >(exec ${coreutils}/bin/cat)'"
        "--run 'exec 2> >(exec ${coreutils}/bin/cat >&2)'"

        ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"''
        "--add-flags ${lib.escapeShellArg commandLineArgs}"
      ];
    in
    ''
      mkdir -p "$out/bin"

      makeWrapper "${browserBinary}" "$out/bin/trivalent" \
        ${lib.concatStringsSep " \\\n  " wrapperArgs}

      mkdir -p "$out/share"
      ln -s -t "$out/share/" '${browserWV}'/share/*
    '';

  passthru = {
    inherit browser;
  };

  meta = browser.meta // {
    license = browser.meta.license ++ lib.optional enableWideVine lib.licenses.unfree;
  };
}
