{ lib, stdenv, fetchurl
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (rec {
<<<<<<< HEAD
  version = "4.13.0";
=======
  version = "4.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "libpfm";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${pname}-${version}.tar.gz";
<<<<<<< HEAD
    sha256 = "sha256-0YuXdkx1VSjBBR03bjNUXQ62DG6/hWgENoE/pbBMw9E=";
=======
    sha256 = "sha256-SwwfU/OaYVJbab6/UyxoBAwbmE11RKiuCESxPNkeHuQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=true"
    "ARCH=${stdenv.hostPlatform.uname.processor}"
    "SYS=${stdenv.hostPlatform.uname.system}"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "Helper library to program the performance monitoring events";
    longDescription = ''
      This package provides a library, called libpfm4 which is used to
      develop monitoring tools exploiting the performance monitoring
      events such as those provided by the Performance Monitoring Unit
      (PMU) of modern processors.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.pierron ];
    platforms = platforms.linux;
  };
} // lib.optionalAttrs ( ! enableShared )
{
  CONFIG_PFMLIB_SHARED = "n";
}
)
