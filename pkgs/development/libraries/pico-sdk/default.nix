{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "pico-sdk";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "sha256-Yf3cVFdI8vR/qcxghcx8fsbYs1qD8r6O5aqZ0AkSLDc=";
  };

  nativeBuildInputs = [ cmake ];

  # SDK contains libraries and build-system to develop projects for RP2040 chip
  # We only need to compile pioasm binary
  sourceRoot = "source/tools/pioasm";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/pico-sdk
    cp -a ../../../* $out/lib/pico-sdk/
    chmod 755 $out/lib/pico-sdk/tools/pioasm/build/pioasm
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/picotool";
    description = "SDK provides the headers, libraries and build system necessary to write programs for the RP2040-based devices";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
