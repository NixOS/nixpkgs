{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "nss_wrapper";
  version = "1.1.11";

  src = fetchurl {
    url = "mirror://samba/cwrap/nss_wrapper-${version}.tar.gz";
    sha256 = "1q5l6w69yc71ly8gcbnkrcbnq6b64cbiiv99m0z5vn5lgwp36igv";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=nss_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
