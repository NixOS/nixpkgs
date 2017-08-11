{ stdenv, fetchzip }:

let
  version = "2.136";
in fetchzip rec {
  name = "roboto-${version}";

  url = "https://github.com/google/roboto/releases/download/v${version}/roboto-unhinted.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "02fanxx2hg0kvxl693rc0fkbrbr2i8b14qmpparkrwmv0j35wnd7";

  meta = {
    homepage = https://github.com/google/roboto;
    description = "The Roboto family of fonts";
    longDescription = ''
      Google’s signature family of fonts, the default font on Android and
      Chrome OS, and the recommended font for Google’s visual language,
      Material Design.
    '';
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
