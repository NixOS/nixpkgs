{ lib, fetchzip }:

let
  pname = "fira-go";
  version = "1.001";
  user = "bBoxType";
  repo = "FiraGo";
  rev = "9882ba0851f88ab904dc237f250db1d45641f45d";
in
fetchzip {
  name = "${pname}-${version}";

  url = "https://github.com/${user}/${repo}/archive/${rev}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    mv $out/Fonts/FiraGO_OTF_1001/{Roman,Italic}/*.otf \
      $out/share/fonts/opentype
    rm -r $out/{Fonts,'Technical Report PDF',OFL.txt,README.md,*.pdf}
  '';

  sha256 = "sha256-MDGRba1eao/yVzSuncJ/nvCG8cpdrI4roVPI1G9qCbU=";

  meta = with lib; {
    homepage = "https://bboxtype.com/typefaces/FiraGO";
    description = ''
      Font with the same glyph set as Fira Sans 4.3 and additionally
      supports Arabic, Devenagari, Georgian, Hebrew and Thai
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.loicreynier ];
    platforms = platforms.all;
  };
}
