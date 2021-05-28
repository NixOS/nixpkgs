{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.7";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "13zd90bfrr0q3j0l0cbc8kiizccw6n8gp727kqnfljh024zw3nr0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  meta = with stdenv.lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "http://netfilter.org/projects/libnftnl";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
