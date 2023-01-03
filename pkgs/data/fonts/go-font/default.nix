{ lib, fetchzip }:

let
  version = "2.010";
  rev = "41969df76e82aeec85fa3821b1e24955ea993001";
in (fetchzip {
  name = "go-font-${version}";
  url = "https://go.googlesource.com/image/+archive/${rev}/font/gofont/ttfs.tar.gz";
  stripRoot = false;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/go-font
    mv $out/*.ttf $out/share/fonts/truetype
    mv $out/README $out/share/doc/go-font/LICENSE
  '';

  sha256 = "175jwq16qjnd2k923n9gcbjizchy7yv4n41dm691sjwrhbl0b13x";
}) // {
  meta = with lib; {
    homepage = "https://blog.golang.org/go-fonts";
    description = "The Go font family";
    changelog = "https://go.googlesource.com/image/+log/refs/heads/master/font/gofont";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sternenseemann ];
    platforms = lib.platforms.all;
    hydraPlatforms = [];
  };
}
