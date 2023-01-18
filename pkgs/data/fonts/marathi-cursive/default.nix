{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "marathi-cursive";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/MihailJP/MarathiCursive/releases/download/v${version}/MarathiCursive-${version}.tar.xz";
    hash = "sha256-JE9T3UMSYn/JfEWuWHikDJIlt4nZl6GzY98v3vG6di4=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/marathi-cursive *.otf *.ttf
    install -m444 -Dt $out/share/doc/${pname}-${version} README *.txt

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MihailJP/MarathiCursive";
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
