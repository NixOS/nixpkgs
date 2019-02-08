{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.2";
  name = "libnftnl-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "0pffmsv41alsn5ac7mwnb9fh3qpwzqk13jrzn6c5i71wq6kbgix5";
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
