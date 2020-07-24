{ stdenv, fetchurl, enableShared ? true }:

stdenv.mkDerivation (rec {
  version = "4.10.1";
  pname = "libpfm";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${pname}-${version}.tar.gz";
    sha256 = "0jabhjx77yppr7x38bkfww6n2a480gj62rw0qp7prhdmg19mf766";
  };

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LDCONFIG=true"
    "ARCH=${stdenv.hostPlatform.uname.processor}"
    "SYS=${stdenv.hostPlatform.uname.system}"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with stdenv.lib; {
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
} // stdenv.lib.optionalAttrs ( ! enableShared )
{
  CONFIG_PFMLIB_SHARED = "n";
}
)
