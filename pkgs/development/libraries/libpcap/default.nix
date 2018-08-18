{ stdenv, fetchurl, fetchpatch, flex, bison }:

stdenv.mkDerivation rec {
  name = "libpcap-1.8.1";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "07jlhc66z76dipj4j5v3dig8x6h3k6cb36kmnmpsixf3zmlvqgb7";
  };

  nativeBuildInputs = [ flex bison ];

  # We need to force the autodetection because detection doesn't
  # work in pure build enviroments.
  configureFlags = [
    ("--with-pcap=" + {
      linux = "linux";
      darwin = "bpf";
    }.${stdenv.hostPlatform.parsed.kernel.name})
  ] ++ stdenv.lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    "ac_cv_linux_vers=2"
  ];

  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure --replace " -arch i386" ""
  '';

  patches = [
    (fetchpatch {
      url    = "https://sources.debian.net/data/main/libp/libpcap/1.8.1-3/debian/patches/disable-remote.diff";
      sha256 = "0dvjax9c0spvq8cdjnkbnm65wlzaml259yragf95kzg611vszfmj";
    })
    # See https://github.com/wjt/bustle/commit/f62cf6bfa662af4ae39effbbd4891bc619e3b4e9
    (fetchpatch {
      url    = "https://github.com/the-tcpdump-group/libpcap/commit/2be9c29d45fb1fab8e9549342a30c160b7dea3e1.patch";
      sha256 = "1g8mh942vr0abn48g0bdvi4gmhq1bz0l80276603y7064qhy3wq5";
    })
    (fetchpatch {
      url    = "https://github.com/the-tcpdump-group/libpcap/commit/1a6b088a88886eac782008f37a7219a32b86da45.patch";
      sha256 = "1n5ylm7ch3i1lh4y2q16b0vabgym8g8mqiqxpqcdkjdn05c1wflr";
    })
  ];

  preInstall = ''mkdir -p $out/bin'';

  meta = with stdenv.lib; {
    homepage = http://www.tcpdump.org;
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
