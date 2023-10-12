{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation rec {
  pname = "commit-mono";
  version = "1.138";

  src = fetchzip {
    url = "https://github.com/eigilnikolajsen/commit-mono/releases/download/${version}/CommitMono-${version}.zip";
    sha256 = "sha256-ae2eeHh57i6d0kDMZ68aXvLGFj+rXhwg1CC8cV3ndAQ=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;
  dontFixup = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ CommitMono-${version}/*.otf
    install -Dm644 -t $out/share/fonts/truetype/ CommitMono-${version}/ttfautohint/*.ttf
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
