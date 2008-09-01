{stdenv, fetchurl, flex, bison}:

stdenv.mkDerivation rec {
  name = "libpcap-0.9.4";
  src = fetchurl {
      url = [
       "mirror://tcpdump/release/${name}.tar.gz"
       "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz"
      ];
      sha256 = "0q0cnn607kfa4y4rbz3glg5lfr8r08s8l08w8fwrr3d6njjzd71p";
  };
  buildInputs = [flex bison];
  configureFlags = "
    ${if stdenv.system == "i686-linux" then "--with-pcap=linux" else ""}
  ";
}
