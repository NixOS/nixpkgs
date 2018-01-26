{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.0.9";
  name = "libnftnl-${version}";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "0d9nkdbdck8sg6msysqyv3m9kjr9sjif5amf26dfa0g3mqjdihgy";
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
