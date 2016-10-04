{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnftnl-1.0.6";

  src = fetchurl {
    url = "http://netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "0zmh190c7212zvzjsn5lm6pf399r4arq7dliiqq6grd174m96fxd";
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
