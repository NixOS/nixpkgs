{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.1.1";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "11asds0r0vd9skbwfbgb1d2hqxr1d92kif4qhhqx2mbyahawm32h";
  };
  
  buildNativeInputs = [ flex bison ];
  
  configureFlags = "--with-pcap=linux";

  preInstall = ''ensureDir $out/bin'';
  
  patches = [ ./libpcap_amd64.patch ];

  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = [ "--with-pcap=linux" "ac_cv_linux_vers=2" ];
  };
}
