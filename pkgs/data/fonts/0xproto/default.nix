{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "0xproto";
  version = "1.603";

  src = let
    underscoreVersion = builtins.replaceStrings ["."] ["_"] version;
  in
    fetchzip {
      url = "https://github.com/0xType/0xProto/releases/download/${version}/0xProto_${underscoreVersion}.zip";
      hash = "sha256-20KqPX6BKlyX+R3zrhDMz3p9Vwgd4RlRe2qhJpic6W4=";
    };

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Free and Open-source font for programming";
    homepage = "https://github.com/0xType/0xProto";
    license = licenses.ofl;
    maintainers = [ maintainers.edswordsmith ];
    platforms = platforms.all;
  };
}
