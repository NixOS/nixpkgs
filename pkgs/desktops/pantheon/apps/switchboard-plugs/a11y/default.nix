{
  lib,
  stdenv,
  substituteAll,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libgee,
  granite,
  gtk3,
  switchboard,
  wingpanel-indicator-a11y,
  onboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-a11y";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0dc5jv335j443rg08cb7p8wvmcg36wrf1vlcfg9r20cksdis9v4l";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit onboard;
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard-plug-a11y/pull/79
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-a11y/commit/08db4b696128a6bf809da3403a818834fcd62b02.patch";
      sha256 = "1s13ak23bdxgcb74wdz3ql192bla5qhabdicqyjv1rp32plhkbg5";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    switchboard
    wingpanel-indicator-a11y
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Switchboard Universal Access Plug";
    homepage = "https://github.com/elementary/switchboard-plug-a11y";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
