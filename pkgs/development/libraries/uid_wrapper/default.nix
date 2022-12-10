{ lib, stdenv, fetchurl, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "uid_wrapper";
  version = "1.2.9";

  src = fetchurl {
    url = "mirror://samba/cwrap/uid_wrapper-${version}.tar.gz";
    sha256 = "sha256-fowCQHKCX+hrq0ZZHPS5CeOZz5j1SCL55SdC9CAEcIQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  meta = with lib; {
    description = "A wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
