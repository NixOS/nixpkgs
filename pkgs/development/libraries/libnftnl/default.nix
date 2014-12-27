{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  name = "libnftnl-1.0.3";

  src = fetchurl {
    url = "netfilter.org/projects/libnftnl/files/${name}.tar.bz2";
    sha256 = "1xr7gis51z9r96s5m5z3dw3f5jx2m1qb7mpvl69631m6nvmff2ng";
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
