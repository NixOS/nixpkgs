{ lib
, stdenv
, fetchFromGitHub
, vegastrike
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vegastrike-utcs-data";
  inherit (vegastrike) version;

  src = fetchFromGitHub {
    owner = "vegastrike";
    repo = "Assets-Production";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XGDg3s8VAtJsO2HnbjA3Yt42euBFH79hIFfSh81jafk=";
  };

  installPhase = ''
    runHook preInstall

    cp -r $src $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Vega Strike - Upon The Coldest Sea - Assets";
    homepage = "https://www.vega-strike.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
    hydraPlatforms = [ ];
  };
})
