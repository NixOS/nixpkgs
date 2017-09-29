{ stdenv, fetchzip}:

fetchzip rec {
  name = "dosis-1.007";

  url = https://github.com/impallari/Dosis/archive/12df1e13e58768f20e0d48ff15651b703f9dd9dc.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf                    -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*README.md \*FONTLOG.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "11a8jmgaly14l7rm3jxkwwv3ngr8fdlkp70nicjk2rg0nny2cvfq";

  meta = with stdenv.lib; {
    description = "A very simple, rounded, sans serif family";
    longDescription = ''
      Dosis is a very simple, rounded, sans serif family.

      The lighter weights are minimalist. The bolder weights have more
      personality. The medium weight is nice and balanced. The overall result is
      a family that's clean and modern, and can express a wide range of
      voices & feelings.

      It comes in 7 incremental weights: ExtraLight, Light, Book, Medium,
      Semibold, Bold & ExtraBold
    '';
    homepage = http://www.impallari.com/dosis;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
