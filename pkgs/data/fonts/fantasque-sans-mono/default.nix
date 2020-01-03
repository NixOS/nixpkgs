{ lib, fetchzip }:

let
  version = "1.8.0";
in

fetchzip rec {
  name = "fantasque-sans-mono-${version}";

  url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono-Normal.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf    -d $out/share/fonts/opentype
    unzip -j $downloadedFile README.md -d $out/share/doc/${name}
  '';

  sha256 = "07y2w6xzkbaj6vr95fvvnmwq1pw9jib4z02xf8937dx812yic9ni";

  meta = with lib; {
    homepage = https://github.com/belluzj/fantasque-sans;
    description = "A font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
