{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.0.0";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "1h3kmj485qz1i08xs4sc3a0bmhs1rvq0h7gycs7paap2szhw8552";
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
