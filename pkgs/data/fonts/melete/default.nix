{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  majorVersion = "0";
  minorVersion = "200";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "melete";
  version = "${majorVersion}.${minorVersion}";

  src = fetchzip {
    url = "https://dotcolon.net/download/fonts/${finalAttrs.pname}_${majorVersion}${minorVersion}.zip";
    hash = "sha256-y1xtNM1Oy92gOvbr9J71XNxb1JeTzOgxKms3G2YHK00=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/opentype $src/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://dotcolon.net/font/${finalAttrs.pname}/";
    description = "A headline typeface that could be used as a movie title";
    platforms = platforms.all;
    maintainers = with maintainers; [ minijackson ];
    license = licenses.ofl;
  };
})
