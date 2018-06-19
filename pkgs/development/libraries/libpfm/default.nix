{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.10.0";
  name = "libpfm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${name}.tar.gz";
    sha256 = "0bldxhcrpav04hi256fmf907gxhyck24j1p998v48zbhm6aykw94";
  };

  installFlags = "DESTDIR=\${out} PREFIX= LDCONFIG=true";

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
}
