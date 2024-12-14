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
  libadwaita,
  libgee,
  libgtop,
  libgudev,
  granite7,
  gtk4,
  packagekit,
  polkit,
  switchboard,
  udisks2,
  fwupd,
  appstream,
  elementary-settings-daemon,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-6b6nuOp4pEufHEmTraSfKpbtPuO3Z9hQJfvKuuyy7as=";
  };

  patches = [
    # Fix build with fwupd 2.0.0
    # https://github.com/elementary/switchboard-plug-about/pull/343
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-about/commit/6f8ba61cb3d82229e19358ede81b77f66dbb06a2.patch";
      hash = "sha256-E9itq/KGzw36S1dAFoCowa/A2/f6Shx9F379nEIM2qI=";
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
    elementary-settings-daemon # for gsettings schemas
    fwupd
    granite7
    gtk4
    libadwaita
    libgee
    libgtop
    libgudev
    packagekit
    polkit
    switchboard
    udisks2
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
