{ stdenv, fetchFromGitHub, pantheon, meson, ninja, pkgconfig, vala, glib
, libgee, granite, gexiv2, elementary-settings-daemon, gtk3, gnome-desktop
, gala, wingpanel, plank, switchboard, gettext, bamf, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-pantheon-shell";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1vrnzxqzl84k8gbrais4j1jyap10kvil4cr769jpr3q3bkbblwrw";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    bamf
    elementary-settings-daemon
    gexiv2
    glib
    gnome-desktop
    granite
    gtk3
    libgee
    plank
    switchboard
  ];

  patches = [
    ./backgrounds.patch # Having https://github.com/elementary/switchboard-plug-pantheon-shell/issues/166 would make this patch uneeded
    ./hardcode-gsettings.patch
    # Fixes https://github.com/elementary/switchboard-plug-pantheon-shell/issues/172
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-pantheon-shell/commit/e4f86df6a6be402db4c979a4b005573618b744d1.patch";
      sha256 = "0sa8611k6sqg96mnp2plmxd30w6zq76bfwszl8ankr9kwsgyc66y";
    })
  ];

  postPatch = ''
    substituteInPlace src/Views/Appearance.vala \
      --subst-var-by GALA_GSETTINGS_PATH ${glib.getSchemaPath gala}
    substituteInPlace src/Views/Appearance.vala \
      --subst-var-by WINGPANEL_GSETTINGS_PATH ${glib.getSchemaPath wingpanel}
  '';


  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Desktop Plug";
    homepage = https://github.com/elementary/switchboard-plug-pantheon-shell;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
