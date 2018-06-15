{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.1";
  name = "libnftnl-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "1wmgjfcb35mscb2srzia5931srygywrs1aznxmg67v177x0nasjx";
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
