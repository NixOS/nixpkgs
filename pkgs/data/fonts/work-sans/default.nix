{ lib, fetchzip }:

let
  version = "2.010";
in
fetchzip {
  name = "work-sans-${version}";

  url = "https://github.com/weiweihuanghuang/Work-Sans/archive/refs/tags/v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "*/fonts/*.ttf" -d $out/share/fonts/opentype
  '';

  sha256 = "sha256-S4O5EoKY4w/p+MHeHRCmPyQRAOUfEwNiETxMgNcsrws=";

  meta = with lib; {
    description = "A grotesque sans";
    homepage = "https://weiweihuanghuang.github.io/Work-Sans/";
    license = licenses.ofl;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
