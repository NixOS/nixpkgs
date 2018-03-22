{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, itstool, desktop-file-utils, gnome3, glib, gtk3, libexif, libtiff, colord, colord-gtk, libcanberra-gtk3, lcms2, vte, exiv2 }:

let
  pname = "gnome-color-manager";
  version = "3.26.0";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1kbi46vk0qf0gxiwm4yhsx8931r7c9cg0c4244j8ncr0hph008b5";
  };

  nativeBuildInputs = [ meson ninja pkgconfig gettext itstool desktop-file-utils ];
  buildInputs = [ glib gtk3 libexif libtiff colord colord-gtk libcanberra-gtk3 lcms2 vte exiv2 ];

  patches = [
    # https://bugzilla.gnome.org/show_bug.cgi?id=791158
    (fetchurl {
      url = https://bugzilla.gnome.org/attachment.cgi?id=364865;
      sha256 = "1zh1aql6rwzfhy2xbdw0jqgzrl9l6wf0jcbdkjd67ykbmynh2cmv";
    })
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A set of graphical utilities for color management to be used in the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
