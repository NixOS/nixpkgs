{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "3270font";
  version = "3.0.1";

  src = fetchzip {
    url = "https://github.com/rbanffy/3270font/releases/download/v${version}/3270_fonts_d916271.zip";
    sha256 = "sha256-Zi6Lp5+sqfjIaHmnaaemaw3i+hXq9mqIsK/81lTkwfM=";
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
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Monospaced font based on IBM 3270 terminals";
    homepage = "https://github.com/rbanffy/3270font";
    changelog = "https://github.com/rbanffy/3270font/blob/v${version}/CHANGELOG.md";
    license = [ licenses.bsd3 licenses.ofl ];
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
