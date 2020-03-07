{ lib, fetchFromGitHub }:

let
  pname = "TT2020";
  version = "2020-01-05";
in
fetchFromGitHub {
  name = "${pname}-${version}";
  owner = "ctrlcctrlv";
  repo = pname;
  rev = "2b418fab5f99f72a18b3b2e7e2745ac4e03aa612";
  sha256 = "1z0nizvs0gp0xl7pn6xcjvsysxhnfm7aqfamplkyvya3fxvhncds";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -Dm644 -t $out/share/fonts/truetype dist/*.ttf
    install -Dm644 -t $out/share/fonts/woff2 dist/*.woff2
  '';

  meta = with lib; {
    description = "An advanced, open source, hyperrealistic, multilingual typewriter font for a new decade";
    homepage = "https://ctrlcctrlv.github.io/TT2020";
    license = licenses.ofl;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.all;
  };
}
