{ stdenv, fetchurl, flex, bison }:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.9.1";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "153h1378diqyc27jjgz6gg5nxmb4ddk006d9xg69nqavgiikflk3";
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

  meta = with stdenv.lib; {
    homepage = https://www.tcpdump.org;
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
