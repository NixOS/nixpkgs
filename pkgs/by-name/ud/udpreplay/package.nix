{
  stdenv,
  cmake,
  libpcap,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation rec {
  pname = "updreplay";
  version = "1.1.0";
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpcap ];
  src = fetchFromGitHub {
    owner = "rigtorp";
    repo = "udpreplay";
    rev = "v${version}";
    hash = "sha256-kF9a3pjQbFKf25NKyK7uSq0AAO6JK7QeChLhm9Z3wEA=";
  };

  meta = with lib; {
    description = "Replay UDP packets from a pcap file";
    longDescription = ''
      udpreplay is a lightweight alternative to tcpreplay for replaying UDP unicast and multicast streams from a pcap file.
    '';
    homepage = "https://github.com/rigtorp/udpreplay";
    license = licenses.mit;
    maintainers = [ maintainers.considerate ];
    platforms = platforms.linux;
    mainProgram = "udpreplay";
  };
}
