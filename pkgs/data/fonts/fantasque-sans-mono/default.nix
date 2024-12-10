{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fantasque-sans-mono";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono-Normal.zip";
    stripRoot = false;
    hash = "sha256-MNXZoDPi24xXHXGVADH16a3vZmFhwX0Htz02+46hWFc=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm644 README.md -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
