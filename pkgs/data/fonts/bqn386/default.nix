{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "bqn386";
  version = "unstable-2022-05-16";

  src = fetchFromGitHub {
    owner = "dzaima";
    repo = "BQN386";
    rev = "81e18d1eb8cb6b66df9e311b3b63ec086d910d18";
    hash = "sha256-f0MbrxdkEiOqod41U07BvdDFDbFCqJuGyDIcx2Y24D0=";
  };

  outputs = [
    "out"
    "woff2"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/truetype *.ttf
    install -Dm444 -t $woff2/share/fonts/woff2 *.woff2

    runHook postInstall
  '';

  meta = {
    description = "An APL and BQN font extending on APL386";
    homepage = "https://dzaima.github.io/BQN386/";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ skykanin ];
    platforms = lib.platforms.all;
  };
}
