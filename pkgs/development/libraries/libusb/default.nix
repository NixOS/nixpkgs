{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libusb-0.1.12";

  # On non-linux, we get warnings compiling, and we don't want the
  # build to break.
  patchPhase = ''
    sed -i s/-Werror// Makefile.in
  '';

  src = fetchurl {
    url = mirror://sourceforge/libusb/libusb-0.1.12.tar.gz;
    md5 = "caf182cbc7565dac0fd72155919672e6";
  };
}
