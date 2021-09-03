{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, vala
, atk
, cairo
, dconf
, glib
, gtk3
, libwnck
, libX11
, libXfixes
, libXi
, pango
, gettext
, pkg-config
, libxml2
, bamf
, gdk-pixbuf
, libdbusmenu-gtk3
, gnome-menus
, libgee
, wrapGAppsHook
, pantheon
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "elementary-dock";
  version = "unstable-2020-06-11";

  outputs = [ "out" "dev" ];

  repoName = "dock";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = "0a389ee58939d8c91c340df4e5340fc4b23d0b80";
    sha256 = "01vinik73s0vmk56samgf49zr2bl4wjv44x15sz2cmh744llckja";
  };

  patches = [
    # Fix double includedir path in plank.pc
    (fetchpatch {
      url = "https://github.com/elementary/dock/commit/3bc368e2c4fafcd5b8baca2711c773b0e2441c7c.patch";
      sha256 = "0gg35phi1cg7ixljc388i0h70w323r1gqzjhanccnsbjpqsgvs3k";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    libxml2 # xmllint
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    bamf
    cairo
    gdk-pixbuf
    glib
    gnome-menus
    dconf
    gtk3
    libX11
    libXfixes
    libXi
    libdbusmenu-gtk3
    libgee
    libwnck
    pango
  ];

  meta = with lib; {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidak ] ++ pantheon.maintainers;
  };
}
