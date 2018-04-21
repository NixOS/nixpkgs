{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "4.9.0";
  name = "libpfm-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/perfmon2/libpfm4/${name}.tar.gz";
    sha256 = "1qp4g4n6dw42p2w5rkwzdb7ynk8h7g5vg01ybpmvxncgwa7bw3yv";
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
    platforms = platforms.all;
  };
}
