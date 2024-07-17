{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "go-font";
  version = "2.010";

  src = fetchzip {
    url = "https://go.googlesource.com/image/+archive/41969df76e82aeec85fa3821b1e24955ea993001/font/gofont/ttfs.tar.gz";
    stripRoot = false;
    hash = "sha256-rdzt51wY4b7HEr7W/0Ar/FB0zMyf+nKLsOT+CRSEP3o=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/go-font
    mv *.ttf $out/share/fonts/truetype
    mv README $out/share/doc/go-font/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://blog.golang.org/go-fonts";
    description = "The Go font family";
    changelog = "https://go.googlesource.com/image/+log/refs/heads/master/font/gofont";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = lib.platforms.all;
  };
}
