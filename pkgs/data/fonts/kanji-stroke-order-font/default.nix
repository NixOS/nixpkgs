{ lib, mkFont, fetchzip, fetchurl, unzip }:

mkFont rec {
  pname = "kanji-stroke-order-font";
  version = "4.002";

  src = fetchzip {
    url = "https://drive.google.com/uc?export=download&id=1gd5vUzwgfUSggn8ZbEG2m03x3bbwYPfL";
    sha256 = "10zbwbcvb07ma727d3illnarywmr6vvxb4ymzgiwgk21zfcc63cs";
    # for some reason, unpack fails without this
    postFetch = "unzip $downloadedFile -d $out";
  };

  meta = with lib; {
    description = "Font containing stroke order diagrams for over 6500 kanji, 180 kana and other characters";
    homepage = "https://sites.google.com/site/nihilistorguk/";

    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ ptrhlm ];
    platforms = platforms.all;
  };
}
