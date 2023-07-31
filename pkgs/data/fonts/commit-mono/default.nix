{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "commit-mono";
  version = "1.132";

  src = fetchzip {
    url = "https://github.com/eigilnikolajsen/commit-mono/releases/download/${version}/CommitMono-${version}.zip";
    sha256 = "sha256-a9zxzjfOFmqemSIb4Tav0l7YtKvbyizDy+1dwPuZ4d4=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;
  dontFixup = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    runHook postInstall
  '';

  meta = with lib; {
    description = "An anonymous and neutral programming typeface focused on creating a better reading experience";
    homepage = "https://commitmono.com/";
    license = licenses.ofl;
    maintainers = [ maintainers.yoavlavi ];
    platforms = platforms.all;
  };
}
