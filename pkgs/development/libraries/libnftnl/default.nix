{ lib, stdenv, fetchurl, pkg-config, libmnl }:

stdenv.mkDerivation rec {
  version = "1.1.9";
  pname = "libnftnl";

  src = fetchurl {
    url = "https://netfilter.org/projects/${pname}/files/${pname}-${version}.tar.bz2";
    sha256 = "16jbp4fs5dz2yf4c3bl1sb48x9x9wi1chv39zwmfgya1k9pimcp9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = with lib; {
    description = "A userspace library providing a low-level netlink API to the in-kernel nf_tables subsystem";
    homepage = "http://netfilter.org/projects/libnftnl";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
