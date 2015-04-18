{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.5.0";
  name = "libpfm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${name}.tar.gz";
    sha1 = "857eb066724e2a5b723d6802d217c8eddff79082";
  };

  installFlags = "DESTDIR=\${out} PREFIX= LDCONFIG=true";

  meta = {
    description = "Helper library to program the performance monitoring events";
    longDescription = ''
      This package provides a library, called libpfm4 which is used to
      develop monitoring tools exploiting the performance monitoring
      events such as those provided by the Performance Monitoring Unit
      (PMU) of modern processors.
    '';
    licence = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.pierron ];
    platforms = stdenv.lib.platforms.all;
  };
}