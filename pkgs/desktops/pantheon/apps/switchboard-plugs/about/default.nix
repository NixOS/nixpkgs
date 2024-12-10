{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libgee,
  libgtop,
  libgudev,
  libhandy,
  granite,
  gtk3,
  switchboard,
  udisks2,
  fwupd,
  appstream,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-MJybc2yAchU6qMqkoRz45QdhR7bj/UFk2nyxcBivsHI=";
  };

  patches = [
    # Add support for AppStream 1.0
    # https://github.com/elementary/switchboard-plug-about/pull/275
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-about/commit/72d7da13da2824812908276751fd3024db2dd0f8.patch";
      hash = "sha256-R7oW3mL77/JNqxuMiqxtdMlHWMJgGRQBBzVeRiqx8PY=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    appstream
    fwupd
    granite
    gtk3
    libgee
    libgtop
    libgudev
    libhandy
    switchboard
    udisks2
  ];

  mesonFlags = [
    # Does not play nice with the nix-snowflake logo
    "-Dwallpaper=false"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/switchboard-plug-about";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };

}
