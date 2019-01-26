{ stdenv, fetchurl, intltool, pkgconfig, gtk3, vala_0_40, enchant
, wrapGAppsHook, gdk_pixbuf, cmake, ninja, desktop-file-utils
, libnotify, libcanberra-gtk3, libsecret, gmime, isocodes
, gobject-introspection, libpthreadstubs, sqlite, gcr
, gnome3, librsvg, gnome-doc-utils, webkitgtk, fetchpatch }:

let
  pname = "geary";
  version = "0.12.4";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "01ykhkjfkprvh9kp4rzrl6xs2pqibiw44ckvqsn5cs3xy2rlq8mm";
  };

  patches = [
    # Fix build with webkitgtk-2.22
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/geary/commit/5d0f711426d76f878cf9b71f7e8f785199c7cde1.patch;
      sha256 = "1yifng5lfsc6wp7irmi8gjdcfig1cr0chf7rdv3asrk567nmwrsi";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/geary/commit/0d966950a2cba888873cd3a7f4f42bb7a017dc6d.patch;
      sha256 = "1y6v4fnik4w3paj9nl0yqs54998sx1zr9w3940d579p6dsa8f3fg";
    })
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/geary/commit/e091f24b00ec421e1aadd5e360d1550e658ad5ef.patch;
      sha256 = "0d5hc4h9c1hnn2sk18nkpmzdvwm3h746n2zj8n22ax9rj6lxl38l";
    })
    # Fix build with vala 0.40.12
    # See: https://gitlab.gnome.org/GNOME/vala/blob/0.40.12/NEWS#L22
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/geary/commit/088cb2c0aa35ad4b54ea5a0a2edaf0ff96c64b45.patch";
      sha256 = "0cnjmbd3snm8ggmprqa32f7i3w86gs3ylab9p5ffj921dcpvvlb2";
    })
  ];

  nativeBuildInputs = [ vala_0_40 intltool pkgconfig wrapGAppsHook cmake ninja desktop-file-utils gnome-doc-utils gobject-introspection ];
  buildInputs = [
    gtk3 enchant webkitgtk libnotify libcanberra-gtk3 gnome3.libgee libsecret gmime sqlite
    libpthreadstubs gnome3.gsettings-desktop-schemas gcr isocodes
    gdk_pixbuf librsvg gnome3.defaultIconTheme
  ];

  cmakeFlags = [
    "-DISOCODES_DIRECTORY=${isocodes}/share/xml/iso-codes"
  ];

  # TODO: This is bad, upstream should fix their code.
  PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${webkitgtk.dev}/share/gir-1.0";

  preFixup = ''
    # Add geary to path for geary-attach
    gappsWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Geary;
    description = "Mail client for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
