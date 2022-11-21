{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "martian-mono";
  version = "0.9.2";

  src = fetchzip {
    url = "https://github.com/evilmartians/mono/releases/download/v${version}/martian-mono-${version}-otf.zip";
    sha256 = "sha256-whIR7BaEflm/VsF60Xck6ZJDLzTugaTOogHzcEtwCsM=";
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
    description = "Free and open-source monospaced font from Evil Martians";
    homepage = "https://github.com/evilmartians/mono";
    changelog = "https://github.com/evilmartians/mono/raw/v${version}/Changelog.md";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
