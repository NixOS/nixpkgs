{ lib, fetchzip }:

fetchzip {
  name = "MPH-2B-Damase-2";

  url = http://www.wazu.jp/downloads/damase_v.2.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "0yzf12z6fpbgycqwiz88f39iawdhjabadfa14wxar3nhl9n434ql";

  meta = {
  };
}
