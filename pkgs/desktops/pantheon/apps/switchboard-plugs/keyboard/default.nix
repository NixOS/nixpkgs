{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, fetchpatch
, substituteAll
, meson
, ninja
, pkg-config
, vala
, libgee
, granite
, gtk3
, libhandy
, libxml2
, libgnomekbd
, libxklavier
, ibus
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-keyboard";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1nsy9fh6qj5kyg22bs1hm6kpsvarwc63q0hl0nbwymvnhfjf6swp";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-keyboard/pull/377
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-keyboard/commit/6d8bcadba05b4ee1115b891448b0de31bcba3749.patch";
      sha256 = "1bppxakj71r3cfy8sw19xbyngb7r6nyirc4g6pjf02cdidhw3v8l";
    })
    ./0001-Remove-Install-Unlisted-Engines-function.patch
    (substituteAll {
      src = ./fix-paths.patch;
      ibus = ibus;
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    ibus
    libgee
    libgnomekbd
    libhandy
    libxklavier
    switchboard
  ];

  meta = with lib; {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/switchboard-plug-keyboard";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
