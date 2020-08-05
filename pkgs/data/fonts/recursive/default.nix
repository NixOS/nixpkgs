{ lib, fetchzip }:

let
  version = "1.054";
in
fetchzip {
  name = "recursive-${version}";

  url = "https://github.com/arrowtype/recursive/releases/download/${version}/ArrowType-Recursive-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/
    unzip -j $downloadedFile \*.otf -x __MACOSX/\* -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -x __MACOSX/\* -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.woff2 -x __MACOSX/\* -d $out/share/fonts/woff2
  '';

  sha256 = "12ld0w7x5lyvymrnqzfj74a3m6knv7i1795bvnpyljmxxkacscnl";

  meta = with lib; {
    homepage = "https://recursive.design/";
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
