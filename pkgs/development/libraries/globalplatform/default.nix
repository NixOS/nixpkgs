{ stdenv, fetchurl, pkgconfig, zlib, openssl, pcsclite }:

stdenv.mkDerivation rec {
  name = "globalplatform-${version}";
  version  = "6.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/${name}.tar.gz";
    sha256 = "191s9005xbc7i90bzjk4rlw15licd6m0rls9fxli8jyymz2021zy";
  };

  buildInputs = [ zlib pkgconfig openssl pcsclite ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/globalplatform/wiki/Home/;
    description = "Library for interacting with smart card devices";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
