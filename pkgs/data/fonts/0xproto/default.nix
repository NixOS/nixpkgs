{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "0xproto";
  version = "1.601";

  src = let
    underscoreVersion = builtins.replaceStrings ["."] ["_"] version;
  in
    fetchzip {
      url = "https://github.com/0xType/0xProto/releases/download/${version}/0xProto_${underscoreVersion}.zip";
      hash = "sha256-f/5YmyIF66+7w2Tb0V0UKRjwDYDdZ0BEqsEuyN0FaDQ=";
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
