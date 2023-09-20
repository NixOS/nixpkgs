{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "borg-sans-mono";
  version = "0.2.0";

  src = fetchzip {
    # https://github.com/marnen/borg-sans-mono/issues/19
    url = "https://github.com/marnen/borg-sans-mono/files/107663/BorgSansMono.ttf.zip";
    hash = "sha256-nn7TGeVm45t7QI8+eEREBTFg9aShYYKtdEYEwQwO2fQ=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Droid Sans Mono Slashed + Hasklig-style ligatures";
    homepage = "https://github.com/marnen/borg-sans-mono";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ atila ];
  };
}
