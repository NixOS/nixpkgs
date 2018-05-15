{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  name = "libnftnl-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "0v4gywcjvv2vg4zk632al1zv3ad0lx87nshynv110l8n3fhsq3pc";
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
