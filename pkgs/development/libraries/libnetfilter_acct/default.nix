{ stdenv, fetchurl, pkgconfig, libmnl }:

stdenv.mkDerivation rec {
  version = "1.0.3";
  name = "libnetfilter_acct-${version}";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_acct/files/${name}.tar.bz2";
    sha256 = "06lsjndgfjsgfjr43px2n2wk3nr7whz6r405mks3887y7vpwwl22";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libmnl ];

  meta = with stdenv.lib; {
    homepage = http://www.netfilter.org/projects/libnetfilter_acct/;
    description = "Userspace library providing interface to extended accounting infrastructure.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
