{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, granite
, gtk3
, libgee
, wingpanel
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-a11y";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1adx1sx9qh02hjgv5h0gwyn116shjl3paxmyaiv4cgh6vq3ndp3c";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-a11y/pull/48
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-a11y/commit/fb8412d56bc1c42b70e8ee41b837e8024e1297f7.patch";
      sha256 = "0619npdw9wvaz1zk2lzikczyjdqba8v8c9ry9zizvvl4j1i1ad7k";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Universal Access Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-a11y";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
