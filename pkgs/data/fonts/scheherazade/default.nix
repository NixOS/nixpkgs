# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip, version ? "3.300" }:

let
  new = lib.versionAtLeast version "3.000";
  sha256 = {
    "2.100" = "1g5f5f9gzamkq3kqyf7vbzvl4rdj3wmjf6chdrbxksrm3rnb926z";
    "3.300" = "1bja1ma1mnna0qlk3dis31cvq5z1kgcqj7wjp8ml03zc5mpa2wb2";
  }."${version}";
  name = "scheherazade${lib.optionalString new "-new"}-${version}";

in (fetchzip rec {
  inherit name;

  url = "http://software.sil.org/downloads/r/scheherazade/Scheherazade${lib.optionalString new "New"}-${version}.zip";

  inherit sha256;

  meta = with lib; {
    homepage = "https://software.sil.org/scheherazade/";
    description = "A font designed in a similar style to traditional Naskh typefaces";
    longDescription = ''

      Scheherazade${lib.optionalString new " New"}, named after the heroine of
      the classic Arabian Nights tale, is designed in a similar style to
      traditional typefaces such as Monotype Naskh, extended to cover the
      Unicode Arabic repertoire through Unicode ${if new then "14.0" else "8.0"}.

      Scheherazade provides a “simplified” rendering of Arabic script, using
      basic connecting glyphs but not including a wide variety of additional
      ligatures or contextual alternates (only the required lam-alef
      ligatures). This simplified style is often preferred for clarity,
      especially in non-Arabic languages, but may not be considered appropriate
      in situations where a more elaborate style of calligraphy is preferred.

      This package contains the regular and bold styles for the Scheherazade
      font family, along with documentation.
    '';
    downloadPage = "https://software.sil.org/scheherazade/download/";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -l $downloadedFile
    unzip -j $downloadedFile \*.ttf                        -d $out/share/fonts/truetype
    unzip    $downloadedFile \*/documentation/\*           -d $out/share/doc/
    mv $out/share/doc/* $out/share/doc/${name}
    unzip -j $downloadedFile \*/FONTLOG.txt  \*/README.txt -d $out/share/doc/${name}
  '';
})
