{ stdenv, fetchzip }:

fetchzip rec {
  name = "libre-franklin-1.014";

  url = https://github.com/impallari/Libre-Franklin/archive/006293f34c47bd752fdcf91807510bc3f91a0bd3.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf                    -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*README.md \*FONTLOG.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "1rkjp8x62cn4alw3lp7m45q34bih81j2hg15kg5c1nciyqq1qz0z";

  meta = with stdenv.lib; {
    description = "A reinterpretation and expansion based on the 1912 Morris Fuller Benton’s classic.";
    homepage = https://github.com/impallari/Libre-Franklin;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
