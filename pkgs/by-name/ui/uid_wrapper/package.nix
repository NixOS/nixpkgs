{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uid_wrapper";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://samba/cwrap/uid_wrapper-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-rkvzuPCnSPRwUxplBDazkYLIIX7pJpqcfpJcZDgKm9o=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "Wrapper for the user, group and hosts NSS API";
    homepage = "https://git.samba.org/?p=uid_wrapper.git;a=summary;";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
