{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.25";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "1cq3zijmbsnjshkm78kffgqrdsxgg7ypvcf2digdyy0s9himnvwc";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
