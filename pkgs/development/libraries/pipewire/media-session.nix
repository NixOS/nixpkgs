{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, doxygen
, graphviz
, systemd
, pipewire
, glib
, dbus
, alsa-lib
, callPackage
}:

let
  mesonEnable = b: if b then "enabled" else "disabled";
  mesonList = l: "[" + lib.concatStringsSep "," l + "]";

  self = stdenv.mkDerivation rec {
    pname = "pipewire-media-session";
    version = "0.4.1";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "media-session";
      rev = version;
      sha256 = "sha256-e537gTkiNYMz2YJrOff/MXYWVDgHZDkqkSn8Qh+7Wr4=";
    };

    patches = [
      # Fix `ERROR: Tried to access unknown option "session-managers".`
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/media-session/-/commit/dfa740175c83e1cd0d815ad423f90872de566437.diff";
        sha256 = "01rfwq8ipm8wyv98rxal1s5zrkf0pn9hgrngiq2wdbwj6vjdnr1h";
      })
      # Fix attempt to put system service units into pkgs.systemd.
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/media-session/-/commit/2ff6b0baec7325dde229013b9d37c93f8bc7edee.diff";
        sha256 = "18gg7ca04ihl4ylnw78wdyrbvg66m8w43gg0wp258x4nv95gpps2";
      })
    ];

    nativeBuildInputs = [
      doxygen
      graphviz
      meson
      ninja
      pkg-config
    ];

    buildInputs = [
      alsa-lib
      dbus
      glib
      pipewire
      systemd
    ];

    mesonFlags = [
      "-Ddocs=enabled"
      "-Dsystemd-system-service=enabled"
      # We generate these empty files from the nixos module, don't bother installing them
      "-Dwith-module-sets=[]"
    ];

    postUnpack = ''
      patchShebangs source/doc/input-filter-h.sh
      patchShebangs source/doc/input-filter.sh
    '';

    postInstall = ''
      mkdir $out/nix-support
      cd $out/share/pipewire/media-session.d
      for f in *.conf; do
        echo "Generating JSON from $f"
        ${pipewire}/bin/spa-json-dump "$f" > "$out/nix-support/$f.json"
      done
    '';

    passthru = {
      updateScript = ./update-media-session.sh;
      tests = {
        test-paths = callPackage ./test-paths.nix { package = self; } {
          paths-out = [
            "nix-support/alsa-monitor.conf.json"
            "nix-support/bluez-monitor.conf.json"
            "nix-support/media-session.conf.json"
            "nix-support/v4l2-monitor.conf.json"
          ];
          paths-lib = [];
        };
      };
    };

    meta = with lib; {
      description = "Example session manager for PipeWire";
      homepage = "https://pipewire.org";
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = with maintainers; [ jtojnar kranzes ];
    };
  };

in
self
