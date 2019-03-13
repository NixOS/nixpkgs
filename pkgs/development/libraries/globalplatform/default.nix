{ stdenv, fetchurl, pkgconfig, zlib, openssl_1_0_2, pcsclite }:

stdenv.mkDerivation rec {
  name = "globalplatform-${version}";
  version  = "6.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/${name}.tar.gz";
    sha256 = "191s9005xbc7i90bzjk4rlw15licd6m0rls9fxli8jyymz2021zy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ zlib openssl_1_0_2 pcsclite ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/globalplatform/wiki/Home/;
    description = "Library for interacting with smart card devices";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
