{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, pkg-config
, meson
, python3
, ninja
, vala
, gtk3
, libgee
, libhandy
, granite
, gettext
, clutter-gtk
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "switchboard";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "02dfsrfmr297cxpyd5m3746ihcgjyfnb3d42ng9m4ljdvh0dxgim";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    granite
    gtk3
    libgee
    libhandy
  ];

  patches = [
    ./plugs-path-env.patch
    # Upstream code not respecting our localedir
    # https://github.com/elementary/switchboard/pull/214
    (fetchpatch {
      url = "https://github.com/elementary/switchboard/commit/8d6b5f4cbbaf134880252afbf1e25d70033e6402.patch";
      sha256 = "0gwq3wwj45jrnlhsmxfclbjw6xjr8kf6pp3a84vbnrazw76lg5nc";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Extensible System Settings app for Pantheon";
    homepage = "https://github.com/elementary/switchboard";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.switchboard";
  };
}
