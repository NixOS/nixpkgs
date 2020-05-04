{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nss_wrapper-1.1.11";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "1q5l6w69yc71ly8gcbnkrcbnq6b64cbiiv99m0z5vn5lgwp36igv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
