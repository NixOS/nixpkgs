{
  lib,
  stdenv,
  callPackage,
  chromium,
  coreutils,
  makeWrapper,
  ed,
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
      runCommand (browser.name + "-wv") { version = browser.version; } ''
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

  nativeBuildInputs = [
    makeWrapper
    ed
  ];

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

    in
    ''
      mkdir -p "$out/bin"

      makeWrapper "${browserBinary}" "$out/bin/trivalent" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      ed -v -s "$out/bin/trivalent" << EOF
      2i

      # Refuse to run as root (upstream launcher behavior)
      if [ "\$(${coreutils}/bin/id -u)" -eq 0 ]; then
        echo "Trivalent must not be run as root."
        exit 1
      fi

      export CHROME_WRAPPER='trivalent'

    ''
    + lib.optionalString (libPath != "") ''
      # Keep LD_LIBRARY_PATH free of empty segments so cwd .so files aren't loaded
      export LD_LIBRARY_PATH="\$LD_LIBRARY_PATH\''${LD_LIBRARY_PATH:+:}${libPath}"
    ''
    + ''

      # https://github.com/NixOS/nixpkgs/issues/352131
      export LD_PRELOAD=""
      export LD_AUDIT=""
      export LD_PROFILE=""

      # Avoid glycin issues (upstream launcher behavior)
      export GDK_DISABLE=icon-nodes

      export XDG_DATA_DIRS=$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH\''${XDG_DATA_DIRS:+:}\$XDG_DATA_DIRS

    ''
    + lib.optionalString stdenv.hostPlatform.isx86_64 ''
      # Hardware CFI (IBT + shadow stack), as the upstream launcher sets
      export GLIBC_TUNABLES="glibc.cpu.x86_ibt=on:glibc.cpu.x86_shstk=permissive"

    ''
    + lib.optionalString (!xdg-utils.meta.broken) ''
      # Fallback for xdg-open and friends
      export PATH="\$PATH\''${PATH:+:}${xdg-utils}/bin"
    ''
    + ''

      # std{in,out,err} are shared with untrusted child processes (http://crbug.com/376567)
      exec < /dev/null
      exec > >(exec cat)
      exec 2> >(exec cat >&2)

      .
      w
      EOF

      mkdir -p "$out/share"
      for f in '${browser}'/share/*; do
        ln -s -t "$out/share/" "$f"
      done
    '';

  passthru = {
    inherit browser;
  };

  meta = browser.meta // {
    license = browser.meta.license ++ lib.optional enableWideVine lib.licenses.unfree;
  };
}
