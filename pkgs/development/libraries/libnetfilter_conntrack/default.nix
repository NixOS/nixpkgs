{ lib, stdenv, fetchurl, pkg-config, libnfnetlink, libmnl }:

stdenv.mkDerivation rec {
  pname = "libnetfilter_conntrack";
  version = "1.0.9";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_conntrack/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-Z72d9J/jTouCFE9t+5OzIPOEqOpZcn6S/40YtfS1eag=";
  };

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = "https://netfilter.org/projects/libnetfilter_conntrack/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
