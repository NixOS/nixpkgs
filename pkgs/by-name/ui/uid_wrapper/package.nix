{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "uid_wrapper";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://samba/cwrap/uid_wrapper-${version}.tar.gz";
    sha256 = "sha256-9mB9hketooqW+rg8Sa1y/IPrbTiZHKJ7JJWzWP8Pbew=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    description = "Wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
