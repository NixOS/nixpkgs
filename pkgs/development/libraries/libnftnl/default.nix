{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnftnl-1.0.2";

  src = fetchurl {
    url = "netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "1p268cv85l4ipd1p9ipjdrfgba14cblp01apv7wc44zmwfr2gkkq";
  };

  buildInputs = [ pkgconfig libmnl ];

  meta = with stdenv.lib; {
    description = "a userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = http://netfilter.org/projects/libnftnl;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
