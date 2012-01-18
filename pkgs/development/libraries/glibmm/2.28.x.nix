{ stdenv, fetchurl_gnome, pkgconfig, glib, libsigcxx }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "glibmm";
    major = "2"; minor = "28"; patchlevel = "2"; extension = "xz";
    sha256 = "1qyb8jb9avfzcdyhldxx7qljjhf30czwnh7c2r9p0x4nin2rjkpq";
  };

  buildNativeInputs = [pkgconfig];
  propagatedBuildInputs = [glib libsigcxx];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
