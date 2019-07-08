{ stdenv, fetchurl, pkgconfig, udev, glib, gobject-introspection, gnome3 }:

let
  pname = "libgudev";
in stdenv.mkDerivation rec {
  name = "libgudev-${version}";
  version = "232";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "ee4cb2b9c573cdf354f6ed744f01b111d4b5bed3503ffa956cefff50489c7860";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection ];
  buildInputs = [ udev glib ];

  # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway.
  configureFlags = [ "--disable-umockdev" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/libgudev;
    maintainers = [ maintainers.eelco ] ++ gnome3.maintainers;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
