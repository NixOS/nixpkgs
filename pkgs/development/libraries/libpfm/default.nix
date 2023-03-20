{ lib, stdenv, fetchurl
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (rec {
  version = "4.12.0";
  pname = "libpfm";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${pname}-${version}.tar.gz";
    sha256 = "sha256-SwwfU/OaYVJbab6/UyxoBAwbmE11RKiuCESxPNkeHuQ=";
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
