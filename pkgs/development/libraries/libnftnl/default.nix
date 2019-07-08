{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.3";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "03xszkcpqk3s1rqc6vh7g5j13kh3d3yjnvjhk5scds3an39rgp92";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  meta = with stdenv.lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = http://netfilter.org/projects/libnftnl;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
