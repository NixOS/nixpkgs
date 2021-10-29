{ lib, fetchzip }:

let
  version = "7.01";
in
fetchzip {
  name = "i.ming-${version}";
  url = "https://raw.githubusercontent.com/ichitenfont/I.Ming/${version}/${version}/I.Ming-${version}.ttf";
  sha256 = "1b2dj7spkznpkad8a0blqigj9f6ism057r0wn9wdqg5g88yp32vd";

  postFetch = ''
    install -DT -m444 $downloadedFile $out/share/fonts/truetype/I.Ming/I.Ming.ttf
  '';

  meta = with lib; {
    description = "An open source Pan-CJK serif typeface";
    homepage = "https://github.com/ichitenfont/I.Ming";
    license = licenses.ipa;
    platforms = platforms.all;
    maintainers = [ maintainers.linsui ];
  };
}
