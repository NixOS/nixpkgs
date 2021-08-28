{ lib, stdenv, fetchurl, pkg-config, zlib, openssl_1_0_2, pcsclite }:

stdenv.mkDerivation rec {
  pname = "globalplatform";
  version  = "6.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/${pname}-${version}.tar.gz";
    sha256 = "191s9005xbc7i90bzjk4rlw15licd6m0rls9fxli8jyymz2021zy";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zlib openssl_1_0_2 pcsclite ];

  meta = with lib; {
    homepage = "https://sourceforge.net/p/globalplatform/wiki/Home/";
    description = "Library for interacting with smart card devices";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
