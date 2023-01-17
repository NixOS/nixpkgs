{ lib, stdenv, fetchurl, flex, bison, bluez, pkg-config, withBluez ? false }:

stdenv.mkDerivation rec {
  pname = "libpcap";
  version = "1.10.1";

  src = fetchurl {
    url = "https://www.tcpdump.org/release/${pname}-${version}.tar.gz";
    sha256 = "sha256-7ShfSsyvBTRPkJdXV7Pb/ncrpB0cQBwmSLf6RbcRvdQ=";
  };

  nativeBuildInputs = [ flex bison ]
    ++ lib.optionals withBluez [ bluez.dev pkg-config ];

  # We need to force the autodetection because detection doesn't
  # work in pure build environments.
  configureFlags = [
    "--with-pcap=${if stdenv.isLinux then "linux" else "bpf"}"
  ] ++ lib.optionals stdenv.isDarwin [
    "--disable-universal"
  ] ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform)
    [ "ac_cv_linux_vers=2" ];

  postInstall = ''
    if [ "$dontDisableStatic" -ne "1" ]; then
      rm -f $out/lib/libpcap.a
    fi
  '';

  meta = with lib; {
    homepage = "https://www.tcpdump.org";
    description = "Packet Capture Library";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.bsd3;
  };
}
