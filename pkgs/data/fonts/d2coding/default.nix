{ lib, fetchzip, unzip }:

let
  version = "1.3.2";
  pname = "d2codingfont";

in fetchzip {
  name = "${pname}-${version}";
  url = "https://github.com/naver/${pname}/releases/download/VER${version}/D2Coding-Ver${version}-20180524.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*-all.ttc -d $out/share/fonts/truetype/
  '';

  sha256 = "1812r82530wzfki7k9cm35fy6k2lvis7j6w0w8svc784949m1wwj";

  meta = with lib; {
    description = "Monospace font with support for Korean and latin characters";
    longDescription = ''
      D2Coding is a monospace font developed by a Korean IT Company called Naver.
      Font is good for displaying both Korean characters and latin characters,
      as sometimes these two languages could share some similar strokes.
      Since verion 1.3, D2Coding font is officially supported by the font
      creator, with symbols for Powerline.
    '';
    homepage = https://github.com/naver/d2codingfont;
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
