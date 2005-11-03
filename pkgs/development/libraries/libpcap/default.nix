{stdenv, fetchurl, flex, bison}:

stdenv.mkDerivation {
  name = "libpcap-0.9.4";
  src = fetchurl {
      url = http://www.tcpdump.org/release/libpcap-0.9.4.tar.gz;
      md5 = "79025766e8027df154cb1f32de8a7974";
  };
  buildInputs = [flex bison];
}
