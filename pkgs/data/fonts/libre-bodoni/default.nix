{ lib, fetchFromGitHub }:

fetchFromGitHub rec {
  name = "libre-bodoni-2.000";

  owner = "impallari";
  repo = "Libre-Bodoni";
  rev = "995a40e8d6b95411d660cbc5bb3f726ffd080c7d";

  postFetch = ''
    tar xf $downloadedFile --strip=1
    install -m444 -Dt $out/share/fonts/opentype */v2000\ -\ initial\ glyphs\ migration/OTF/*.otf
    install -m444 -Dt $out/share/doc/${name}    README.md FONTLOG.txt
  '';

  sha256 = "0my0i5a7f0d27m6dcdirjmlcnswqqfp8gl3ccxa5f2wkn3qlzkvz";

  meta = with lib; {
    description = "Bodoni fonts adapted for today's web requirements";
    longDescription = ''
      The Libre Bodoni fonts are based on the 19th century Morris Fuller
      Benton's ATF design, but specifically adapted for today's web
      requirements.

      They are a perfect choice for everything related to elegance, style,
      luxury and fashion.

      Libre Bodoni currently features four styles: Regular, Italic, Bold and
      Bold Italic.
    '';
    homepage = https://github.com/impallari/Libre-Bodoni;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
