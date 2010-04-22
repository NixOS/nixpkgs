{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-3.24";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "0038v3ddg0mpg2iakdhgd5bg69xw4625si91nf1b0vrh9791fiz4";
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
