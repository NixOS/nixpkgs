{ lib
, stdenv
, fetchurl
, flex
, bison
, bluez
, libnl
, libxcrypt
, pkg-config
, withBluez ? false
, withRemote ? false

# for passthru.tests
, ettercap
, nmap
, ostinato
, tcpreplay
, vde2
, wireshark
, python3
, haskellPackages
}:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.10.4";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    hash = "sha256-7RmgOD+tcuOtQ1/SOdfNgNZJFrhyaVUBWdIORxYOvl8=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libnl ]
    ++ lib.optionals withRemote [ libxcrypt ];

  nativeBuildInputs = [ flex bison ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ]
    ++ lib.optionals withBluez [ bluez.dev ];

  # We need to force the autodetection because detection doesn't
  # work in pure build environments.
  configureFlags = [
    "--with-pcap=${if stdenv.hostPlatform.isLinux then "linux" else "bpf"}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--disable-universal"
  ] ++ lib.optionals withRemote [
    "--enable-remote"
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform)
    [ "ac_cv_linux_vers=2" ];

  postInstall = ''
    if [ "$dontDisableStatic" -ne "1" ]; then
      rm -f $out/lib/libpcap.a
    fi
  '';

  passthru.tests = {
    inherit ettercap nmap ostinato tcpreplay vde2 wireshark;
    inherit (python3.pkgs) pcapy-ng scapy;
    haskell-pcap = haskellPackages.pcap;
  };

  meta = with lib; {
    homepage = "https://www.tcpdump.org";
    description = "Packet Capture Library";
    mainProgram = "pcap-config";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
