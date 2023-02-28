{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "nss_wrapper";
  version = "1.1.15";

  src = fetchurl {
    url = "mirror://samba/cwrap/nss_wrapper-${version}.tar.gz";
    sha256 = "sha256-Nvh0gypPIVjgT2mqd+VRXhbPbjv4GWjV3YSW231pBq0=";
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
