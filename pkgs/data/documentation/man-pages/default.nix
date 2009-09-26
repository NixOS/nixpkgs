{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.22";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "0b6x5jajbrqls2yvy1xzgr1c4jhs1cp8pid07a34m6wipjr6b5kg";
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
