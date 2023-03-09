{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "sampradaya";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/deepestblue/sampradaya/releases/download/v${version}/Sampradaya.ttf";
    hash = "sha256-ygKMNzHvbLR2A5HHrfY2C9ZUg0yng+JL3cyg6sBKqeQ=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/Sampradaya.ttf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/deepestblue/sampradaya";
    description = "Unicode-compliant Grantha font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
}
