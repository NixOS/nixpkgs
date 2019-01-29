{ stdenv, fetchurl, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "nss_wrapper-1.1.5";

  src = fetchurl {
    url = "mirror://samba/cwrap/${name}.tar.gz";
    sha256 = "0srk7hffhkwl811q4pjy0n0gm8rh26akb2bh6avcpbns0zzn9ldn";
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
