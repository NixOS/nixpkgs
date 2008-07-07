{stdenv, fetchurl, flex, bison}:

stdenv.mkDerivation {
  name = "libpcap-0.9.8";
  src = fetchurl {
      url = [ http://www.tcpdump.org/release/libpcap-0.9.8.tar.gz http://www.sfr-fresh.com/unix/misc/libpcap-0.9.8.tar.gz ];
      sha256 = "1yb2hg8jd1bzq3lbrff1sps4757krvj2c9pm2ixn44a4vsc865f4";
  };
  buildInputs = [flex bison];
  configureFlags = "
    ${if stdenv.system == "i686-linux" then "--with-pcap=linux" else ""}
  ";
}
