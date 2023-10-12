{ lib, stdenv, fetchFromGitHub, cmake
, minimal ? false, }:

stdenv.mkDerivation rec {
  pname = "pico-sdk";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    fetchSubmodules = !minimal;
    sha256 = if minimal then
      "sha256-JNcxd86XNNiPkvipVFR3X255boMmq+YcuJXUP4JwInU="
    else
      "sha256-GY5jjJzaENL3ftuU5KpEZAmEZgyFRtLwGVg3W1e/4Ho=";
  };

  nativeBuildInputs = [ cmake ];

  # SDK contains libraries and build-system to develop projects for RP2040 chip
  # We only need to compile pioasm binary
  sourceRoot = "${src.name}/tools/pioasm";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pico-sdk
    cp -a ../../../* $out/lib/pico-sdk/
    chmod 755 $out/lib/pico-sdk/tools/pioasm/build/pioasm
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/pico-sdk";
    description = "SDK provides the headers, libraries and build system necessary to write programs for the RP2040-based devices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
    # Only minimal on hydra: non-minimal is too big.
    hydraPlatforms = optionals minimal platforms.unix;
  };
}
