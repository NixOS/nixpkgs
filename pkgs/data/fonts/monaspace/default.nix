{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "monaspace";
  version = "1.000";

  src = fetchzip {
    url = "https://github.com/githubnext/monaspace/releases/download/v${version}/monaspace-v${version}.zip";
    sha256 = "sha256-0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
    stripRoot = false;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ *.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "An innovative superfamily of fonts for code";
    homepage = "https://github.com/githubnext/monaspace";
    license = [ licenses.sil ];
    maintainers = [ maintainers.x0ba ];
    platforms = platforms.all;
  };
}
