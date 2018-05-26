{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  name = "libnetfilter_conntrack-${version}";
  version = "1.0.6";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_conntrack/files/${name}.tar.bz2";
    sha256 = "1svzyf3rq9nbrcw1jsricgyhh7x1am8iqn6kjr6mzrw42810ik7g";
  };

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = https://netfilter.org/projects/libnetfilter_conntrack/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
