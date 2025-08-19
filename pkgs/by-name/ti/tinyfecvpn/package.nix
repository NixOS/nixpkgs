{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "tinyfecvpn";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "tinyfecvpn";
    tag = version;
    hash = "sha256-g4dduREH64TDK3Y2PKc5RZiISW4h2ALRh8vQK7jvCZU=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config ];

  patchPhase = ''
    runHook prePatch
    find . -type f -name "makefile" -exec sed "s/ -static/ -g/g" -i \{\} \;
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 tinyvpn $out/bin/tinyvpn
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wangyu-/tinyfecVPN";
    description = "VPN Designed for Lossy Links, with Build-in Forward Error Correction(FEC) Support";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "tinyvpn";
  };
}
