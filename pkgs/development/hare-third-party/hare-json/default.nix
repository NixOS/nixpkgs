{ lib, stdenv, hare, harec, fetchFromSourcehut }:

stdenv.mkDerivation (finalAttrs: {
  pname = "hare-json";
  version = "unstable-2023-09-21";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "hare-json";
    rev = "e24e5dceb8628ff569338e6c4fdba35a5017c5e2";
    hash = "sha256-7QRieokqXarKwLfZynS8Rum9JV9hcxod00BWAUwwliM=";
  };

  nativeBuildInputs = [ hare ];

  configurePhase = ''
    runHook preConfigure

    export HARECACHE="$NIX_BUILD_TOP/.harecache"
    export BINOUT="$NIX_BUILD_TOP/.bin"

    makeFlagsArray+=(
      PREFIX="${builtins.placeholder "out"}"
    )

    runHook postConfigure
  '';

  doCheck = true;

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/hare-json/";
    description = "This package provides JSON support for Hare";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ starzation ];

    inherit (harec.meta) platforms badPlatforms;
  };
})
