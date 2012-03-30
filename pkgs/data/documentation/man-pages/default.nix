{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.38";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.xz";
    sha256 = "10ha41yj5v3rjy73x8kpn65srbcy0iz399vv149bh12lvyv67kvy";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
