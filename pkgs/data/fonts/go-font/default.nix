{ lib, fetchgit }:

let
  version = "2.010";
in (fetchgit {
  name = "go-font-${version}";
  url = "https://go.googlesource.com/image";
  rev = "41969df76e82aeec85fa3821b1e24955ea993001";

  postFetch = ''
    mv $out/* .
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/go-font
    cp font/gofont/ttfs/* $out/share/fonts/truetype
    mv $out/share/fonts/truetype/README $out/share/doc/go-font/LICENSE
  '';

  sha256 = "dteUL/4ZUq3ybL6HaLYqu2Tslx3q8VvELIY3tVC+ODo=";
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
