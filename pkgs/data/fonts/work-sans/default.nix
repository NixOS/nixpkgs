{ lib, fetchFromGitHub }:

let
  version = "1.6";
in fetchFromGitHub {
  name = "work-sans-${version}";

  owner = "weiweihuanghuang";
  repo = "Work-Sans";
  rev = "v${version}";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype/ fonts/desktop/*.otf
    install -m444 -Dt $out/share/fonts/truetype/ fonts/webfonts/ttf/*.ttf
    install -m444 -Dt $out/share/fonts/woff/     fonts/webfonts/woff/*.woff
    install -m444 -Dt $out/share/fonts/woff2/    fonts/webfonts/woff2/*.woff2
  '';

  sha256 = "01kjidk6zv80rqxapcdwhd9wxzrjfc6lj4gkf6dwa4sskw5x3b8a";

  meta = with lib; {
    description = "A grotesque sans";
    homepage = "https://weiweihuanghuang.github.io/Work-Sans/";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
