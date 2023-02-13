{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "nss_wrapper";
  version = "1.1.12";

  src = fetchurl {
    url = "mirror://samba/cwrap/nss_wrapper-${version}.tar.gz";
    sha256 = "sha256-zdBg/wnAO32i0wsMta00dSNNQ4rqJ5A9slwvFvVwIYY=";
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
