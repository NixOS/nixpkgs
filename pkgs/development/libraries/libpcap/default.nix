{stdenv, fetchurl, flex, bison}:

stdenv.mkDerivation {
  name = "libpcap-0.9.5";
  src = fetchurl {
      url = http://www.tcpdump.org/release/libpcap-0.9.5.tar.gz;
      md5 = "b0626ad59004fe5767ddd2ce743a2271";
  };
  buildInputs = [flex bison];
  configureFlags = "
    ${if stdenv.system == "i686-linux" then "--with-pcap=linux" else ""}
  ";
}
