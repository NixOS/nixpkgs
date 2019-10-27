{ stdenv, fetchurl, pkgconfig, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  pname = "libnetfilter_conntrack";
  version = "1.0.7";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_conntrack/files/${pname}-${version}.tar.bz2";
    sha256 = "1dl9z50yny04xi5pymlykwmy6hcfc9p4nd7m47697zwxw98m6s1k";
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
