{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, python3
, ninja
, vala
, desktop-file-utils
, gettext
, libxml2
, gtk3
, granite
, libgee
, bamf
, libcanberra
, libcanberra-gtk3
, gnome-desktop
, mutter
, clutter
, plank
, elementary-icon-theme
, elementary-settings-daemon
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "03cq9ihgjasnv1n4v3dn1m3ypzj26k2ybd5b1a7yrbprb35zbrs4";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    clutter
    elementary-icon-theme
    gnome-desktop
    elementary-settings-daemon
    granite
    gtk3
    libcanberra
    libcanberra-gtk3
    libgee
    mutter
    plank
  ];

  patches = [
    ./plugins-dir.patch
    ./use-new-notifications-default.patch
  ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta =  with stdenv.lib; {
    description = "A window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
