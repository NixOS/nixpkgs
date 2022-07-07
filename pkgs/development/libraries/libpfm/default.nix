{ lib, stdenv, fetchurl
, enableShared ? !stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (rec {
  version = "4.11.0";
  pname = "libpfm";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${pname}-${version}.tar.gz";
    sha256 = "1k7yp6xfsglp2b6271r622sjinlbys0dk24n9iiv656y5f3zi9ax";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=true"
    "ARCH=${stdenv.hostPlatform.uname.processor}"
    "SYS=${stdenv.hostPlatform.uname.system}"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

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
