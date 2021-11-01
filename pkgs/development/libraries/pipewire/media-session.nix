{ stdenv
, lib
, fetchFromGitLab
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
    version = "0.4.0";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "media-session";
      rev = version;
      sha256 = "sha256-zhOvBlG7DuQkJ+ZZBhBhfKwk+bbLljpt3w4JlK3cJLk=";
    };

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
