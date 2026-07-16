{
  stdenv,
  cmake,
  libpcap,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "updreplay";
  version = "1.1.0";
  nativeBuildInputs = [ cmake ];
  buildInputs = [ libpcap ];
  src = fetchFromGitHub {
    owner = "rigtorp";
    repo = "udpreplay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kF9a3pjQbFKf25NKyK7uSq0AAO6JK7QeChLhm9Z3wEA=";
  };

  patches = [
    # Increase minimum CMake required to 3.5
    (fetchpatch {
      url = "https://github.com/rigtorp/udpreplay/commit/52bd71d6c004cd69899dbe8d529f3ce0a8154e7f.patch?full_index=1";
      hash = "sha256-nWtC77SNpNDDkEli5loc8eVJ1ll0AdgEKQ4pV84JoSk=";
    })
  ];

  meta = {
    description = "Replay UDP packets from a pcap file";
    longDescription = ''
      udpreplay is a lightweight alternative to tcpreplay for replaying UDP unicast and multicast streams from a pcap file.
    '';
    homepage = "https://github.com/rigtorp/udpreplay";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.considerate ];
    platforms = lib.platforms.linux;
    mainProgram = "udpreplay";
  };
})
