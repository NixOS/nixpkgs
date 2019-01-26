{ stdenv, fetchurl, fetchpatch, glib, pkgconfig, perl, gettext, gobject-introspection, libtool, gnome3, gtk-doc }:
let
  pname = "libgtop";
  version = "2.38.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "04mnxgzyb26wqk6qij4iw8cxwl82r8pcsna5dg8vz2j3pdi0wv2g";
  };

  patches = [
    # Fix darwin build
    (fetchpatch {
        url = https://gitlab.gnome.org/GNOME/libgtop/commit/42b049f338363f92c1e93b4549fc944098eae674.patch;
        sha256 = "0kf9ihgb0wqji6dcvg36s6igkh7b79k6y1n7w7wzsxya84x3hhyn";
      })
  ];

  propagatedBuildInputs = [ glib ];
  nativeBuildInputs = [ pkgconfig gnome3.gnome-common libtool gtk-doc perl gettext gobject-introspection ];

  preConfigure = ''
    ./autogen.sh
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "A library that reads information about processes and the running system";
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.unix;
  };
}
