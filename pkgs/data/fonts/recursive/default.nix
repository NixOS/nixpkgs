{ lib, fetchzip }:

let
  version = "1.082";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/v${version}/ArrowType-Recursive-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "1hjyjvzhfgqw58py4gk58fwyp5pxr3j8j76ppj6apg4dndfhs0lp";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
