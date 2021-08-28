{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pth-2.0.7";

  src = fetchurl {
    url = "mirror://gnu/pth/${name}.tar.gz";
    sha256 = "0ckjqw5kz5m30srqi87idj7xhpw6bpki43mj07bazjm2qmh3cdbj";
  };

  preConfigure = lib.optionalString stdenv.isAarch32 ''
    configureFlagsArray=("CFLAGS=-DJB_SP=8 -DJB_PC=9")
  '' + lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    configureFlagsArray+=("ac_cv_check_sjlj=ssjlj")
  '';

  meta = with lib; {
    description = "The GNU Portable Threads library";
    homepage = "https://www.gnu.org/software/pth";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
