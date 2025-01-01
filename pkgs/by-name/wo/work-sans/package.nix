{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "work-sans";
  version = "2.010";

  src = fetchzip {
    url = "https://github.com/weiweihuanghuang/Work-Sans/archive/refs/tags/v${version}.zip";
    hash = "sha256-cedcx3CpcPZk3jxxIs5Bz78dxZNtOemvXnUBO6zl2dw=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/variable/*.ttf fonts/static/TTF/*.ttf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Grotesque sans";
    homepage = "https://weiweihuanghuang.github.io/Work-Sans/";
    license = licenses.ofl;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
