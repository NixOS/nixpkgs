{ stdenv
, wrapGAppsHook
, gettext
, file
, python3
, pavucontrol
, fetchFromGitHub
, utillinux
, gobject-introspection
, gnome3
, glib
, gtk3
, xapps
}:

stdenv.mkDerivation rec {
  pname = "blueberry";
  version = "1.3.9";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "0llvz1h2dmvhvwkkvl0q4ggi1nmdbllw34ppnravs5lybqkicyw9";
  };

  buildInputs = [
    utillinux # rfkill
    glib
    gtk3
    pavucontrol
    (python3.withPackages(ps: with ps; [ pygobject3 setproctitle pydbus ]))
    gnome3.gnome-bluetooth
    xapps
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gettext
    gobject-introspection
  ];

  postPatch = ''
    find . -type f -exec sed -i \
      -e s,/usr/lib/blueberry,$out/lib/blueberry,g \
      -e s,/usr/bin/pavucontrol,${pavucontrol}/bin/pavucontrol,g \
      -e s,/usr/share/locale,$out/share/locale,g \
      -e s,/usr/sbin/rfkill,${utillinux}/bin/rfkill,g \
      -e s,/usr/bin/rfkill,${utillinux}/bin/rfkill,g \
      {} +
  '';

  installPhase = ''
    mv usr $out
    mv etc $out/
  '';
}
