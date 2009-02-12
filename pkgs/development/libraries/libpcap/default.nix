{stdenv, fetchurl, flex, bison}:

stdenv.mkDerivation rec {
  name = "libpcap-1.0.0";
  src = fetchurl {
      url = [
       "mirror://tcpdump/release/${name}.tar.gz"
       "http://www.sfr-fresh.com/unix/misc/${name}.tar.gz"
      ];
      sha256 = "1h3kmj485qz1i08xs4sc3a0bmhs1rvq0h7gycs7paap2szhw8552";
  };
  buildInputs = [flex bison];
  configureFlags = [
      "${if stdenv.system == "i686-linux" then "--with-pcap=linux" else ""}"
       "--with-pcap=linux"
  ];

  preInstall = ''ensureDir $out/bin'';
  patches = if stdenv.system == "i686-linux"
      then []
      else [ ./libpcap_amd64.patch ];

}
