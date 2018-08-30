{ stdenv
, autoreconfHook
, fetchurl
, fetchpatch
, gettext
, glib
, gnome-bluetooth
, gnome-desktop
, gnome-session
, gnome3
, gsettings-desktop-schemas
, gtk
, ibus
, intltool
, libcanberra-gtk3
, libpulseaudio
, libxkbfile
, libxml2
, metacity
, pkgconfig
, polkit
, substituteAll
, upower
, xkeyboard_config }:

let
  pname = "gnome-flashback";
  version = "3.28.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ra8bfwgwqw47zx2h1q999g7l4dnqh7sv02if3zk8pkw3sm769hg";
  };

  patches =[
    (substituteAll {
      src = ./fix-paths.patch;
      inherit metacity;
      gnomeSession = gnome-session;
    })

    # https://github.com/NixOS/nixpkgs/issues/36468
    # https://gitlab.gnome.org/GNOME/gnome-flashback/issues/3
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gnome-flashback/commit/eabd34f64adc43b8783920bd7a2177ce21f83fbc.patch;
      sha256 = "116c5zy8cp7d06mrsn943q7vj166086jzrfzfqg7yli14pmf9w1a";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    gettext
    libxml2
    pkgconfig
  ];

  buildInputs = [
    glib
    gnome-bluetooth
    gnome-desktop
    gsettings-desktop-schemas
    gtk
    ibus
    libcanberra-gtk3
    libpulseaudio
    libxkbfile
    polkit
    upower
    xkeyboard_config
  ];

  doCheck = true;

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "GNOME 2.x-like session for GNOME 3";
    homepage = https://wiki.gnome.org/Projects/GnomeFlashback;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
