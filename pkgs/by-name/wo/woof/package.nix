{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "woof";
  version = "2022-01-13";

  src = fetchFromGitHub {
    owner = "simon-budig";
    repo = "woof";
    rev = "f51e9db264118d4cbcd839348c4a6223fda49813";
    sha256 = "sha256-tk55q2Ew2mZkQtkxjWCuNgt9t+UbjH4llIJ42IruqGY=";
  };

  propagatedBuildInputs = [ python3 ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin woof
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.home.unix-ag.org/simon/woof.html";
    description = "Web Offer One File - Command-line utility to easily exchange files over a local network";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
    mainProgram = "woof";
  };
}
