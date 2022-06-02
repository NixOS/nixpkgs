{ lib, fetchzip }:

fetchzip rec {
  name = "encode-sans-1.002";

  url = "https://github.com/impallari/Encode-Sans/archive/11162b46892d20f55bd42a00b48cbf06b5871f75.zip";

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf                    -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*README.md \*FONTLOG.txt -d "$out/share/doc/${name}"
  '';

  sha256 = "16mx894zqlwrhnp4rflgayxhxppmsj6k7haxdngajhb30rlwf08p";

  meta = with lib; {
    description = "A versatile sans serif font family";
    longDescription = ''
      The Encode Sans family is a versatile workhorse. Featuring a huge range of
      weights and widths, it's ready for all kind of typographic challenges. It
      also includes Tabular and Old Style figures, as well as full set of Small
      Caps and other Open Type features.

      Designed by Pablo Impallari and Andres Torresi.
    '';
    homepage = "https://github.com/impallari/Encode-Sans";
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
