{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "tinymembench";
  version = "0.4.9-unstable-2017-02-15";

  src = fetchFromGitHub {
    owner = "ssvb";
    repo = "tinymembench";
    rev = "a2cf6d7e382e3aea1eb39173174d9fa28cad15f3";
    hash = "sha256-INgvyu7jAA+07vkO9DsIDMcEy713jcnaEx3CI6GTMDA=";
  };

  installPhase = ''
    runHook preInstall
    install -D tinymembench $out/bin/tinymembench
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/ssvb/tinymembench";
    description = "Simple benchmark for memory throughput and latency";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tinymembench";
    maintainers = with lib.maintainers; [ lorenz ];
=======
  meta = with lib; {
    homepage = "https://github.com/ssvb/tinymembench";
    description = "Simple benchmark for memory throughput and latency";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "tinymembench";
    maintainers = with maintainers; [ lorenz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
