{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libburn-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "http://files.libburnia-project.org/releases/${name}.tar.gz";
    sha256 = "19lxnzn8bz70glrrrn2hs43gf5g7gfbcka9rcbckhv1pb7is509y";
  };

  meta = with stdenv.lib; {
    homepage = http://libburnia-project.org/;
    description = "A library by which preformatted data get onto optical media: CD, DVD, BD (Blu-Ray)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ abbradar vrthra ];
    platforms = with platforms; unix;
  };
}
