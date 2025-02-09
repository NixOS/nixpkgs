{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "tinymembench";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "ssvb";
    repo = "tinymembench";
    rev = "v${version}";
    hash = "sha256-N6jHRLqVSNe+Mk3WNfIEBGtVC7Y6/sERVaeAD68LQJc=";
  };

  installPhase = ''
    runHook preInstall
    install -D tinymembench $out/bin/tinymembench
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ssvb/tinymembench";
    description = "Simple benchmark for memory throughput and latency";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "tinymembench";
    maintainers = with maintainers; [ lorenz ];
  };
}
