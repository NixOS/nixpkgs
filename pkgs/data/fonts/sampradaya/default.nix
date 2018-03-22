{ lib, fetchzip }:

fetchzip {
  name = "sampradaya-2015-05-26";

  url = "https://bitbucket.org/OorNaattaan/sampradaya/raw/afa9f7c6ab17e14bd7dd74d0acaec2f75454dfda/Sampradaya.ttf";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/Sampradaya.ttf";

  sha256 = "1pqyj5r5jc7dk8yyzl7i6qq2m9zvahcjj49a66wwzdby5zyw8dqv";

  meta = with lib; {
    homepage = https://bitbucket.org/OorNaattaan/sampradaya/;
    description = "Unicode-compliant Grantha font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
}
