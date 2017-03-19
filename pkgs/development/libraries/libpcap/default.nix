{ stdenv, fetchurl, fetchpatch, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.8.1";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "07jlhc66z76dipj4j5v3dig8x6h3k6cb36kmnmpsixf3zmlvqgb7";
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

  patches = [
    (fetchpatch {
      url    = "https://sources.debian.net/data/main/libp/libpcap/1.8.1-3/debian/patches/disable-remote.diff";
      sha256 = "0dvjax9c0spvq8cdjnkbnm65wlzaml259yragf95kzg611vszfmj";
    })
  ];

  preInstall = ''mkdir -p $out/bin'';

  crossAttrs = {
    # Stripping hurts in static libraries
    dontStrip = true;
    configureFlags = configureFlags ++ [ "ac_cv_linux_vers=2" ];
  };

  meta = with stdenv.lib; {
    homepage = http://www.tcpdump.org;
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
