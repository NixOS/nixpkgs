{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnftnl-1.0.8";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "0f10cfiyl4c0f8k3brxfrw28x7a6qvrakaslg4jgqncwxycxggg6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  meta = with stdenv.lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = http://netfilter.org/projects/libnftnl;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington fpletz ];
  };
}
