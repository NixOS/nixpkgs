{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.7.4";
  
  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "1c28ykkizd7jqgzrfkg7ivqjlqs9p6lygp26bsw2i0z8hwhi3lvs";
  };
  
  nativeBuildInputs = [ flex bison ];
  
  # We need to force the autodetection because detection doesn't
  # work in pure build enviroments.
  configureFlags =
    if stdenv.isLinux then [ "--with-pcap=linux" ]
    else if stdenv.isDarwin then [ "--with-pcap=bpf" ]
    else [];

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace " -arch i386" ""
  '';

  preInstall = ''mkdir -p $out/bin'';
  
  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = configureFlags ++ [ "ac_cv_linux_vers=2" ];
  };

  meta = {
    homepage = http://www.tcpdump.org;
    description = "Packet Capture Library";
    platforms = stdenv.lib.platforms.unix;
  };
}
