{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libgphoto2-2.1.5";

  src = fetchurl {
    url = http://heanet.dl.sourceforge.net/sourceforge/gphoto/libgphoto2-2.1.5.tar.gz;
    md5 = "210844f0d88f58842917af6eaff06382";
  };
}
