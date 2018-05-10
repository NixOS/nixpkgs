{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  name = "libnetfilter_log-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_log/files/${name}.tar.bz2";
    sha256 = "089vjcfxl5qjqpswrbgklf4wflh44irmw6sk2k0kmfixfmszxq3l";
  };

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Userspace library providing interface to packets that have been logged by the kernel packet filter";
    longDescription = ''
      libnetfilter_log is a userspace library providing interface to packets
      that have been logged by the kernel packet filter. It is is part of a
      system that deprecates the old syslog/dmesg based packet logging. This
      library has been previously known as libnfnetlink_log.
    '';
    homepage = https://netfilter.org/projects/libnetfilter_log/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ orivej ];
  };
}
