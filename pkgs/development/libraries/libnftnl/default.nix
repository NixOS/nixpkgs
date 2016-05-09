{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnftnl-1.0.5";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "15z4kcsklbvy94d24p2r0avyhc2rsvygjqr3gyccg2z30akzbm7n";
  };

  buildInputs = [ pkgconfig libmnl ];

  meta = with stdenv.lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = http://netfilter.org/projects/libnftnl;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
