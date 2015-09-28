{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "re2";
  version = "20140304";

  src = fetchurl {
    url = "https://re2.googlecode.com/files/${name}-${version}.tgz";
    sha256 = "19wn0472c9dsxp35d0m98hlwhngx1f2xhxqgr8cb5x72gnjx3zqb";
  };

  preConfigure = ''
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  meta = {
    homepage = https://code.google.com/p/re2/;
    description = "An efficient, principled regular expression library";
    license = stdenv.lib.licenses.bsd3;
    platforms = with stdenv.lib.platforms; all;
  };
}
