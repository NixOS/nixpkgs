{stdenv, fetchurl, pkgconfig, libusb}:

stdenv.mkDerivation {
  name = "libgphoto2-2.2.1";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libgphoto2-2.2.1.tar.bz2;
    md5 = "69827311733e39fafa9f77bb05e55b77";
  };
  buildInputs = [pkgconfig libusb];

  ## remove this patch when 2.2.2 is released
  patches = [./libgphoto2-2.2.1.patch];
}
