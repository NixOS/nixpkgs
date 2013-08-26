{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2";
  version = "20130802";

  src = fetchurl {
    url = "https://re2.googlecode.com/files/${name}-${version}.tgz";
    sha256 = "12yxbjsnc1ym7jny470wbnb6h3rgsfv0z75vdp12npklck5nmwhp";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  meta = {
    homepage = https://code.google.com/p/re2/;
    description = "An efficient, principled regular expression library";
    license = with stdenv.lib.licenses; bsd3;
    platforms = with stdenv.lib.platforms; all;
  };
}
