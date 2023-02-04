{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation {
  pname = "fira-go";
  version = "1.001";

  src = fetchzip {
    url = "https://github.com/bBoxType/FiraGo/archive/9882ba0851f88ab904dc237f250db1d45641f45d.zip";
    hash = "sha256-WwgPg7OLrXBjR6oHG5061RO3HeNkj2Izs6ktwIxVw9o=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    mv Fonts/FiraGO_OTF_1001/{Roman,Italic}/*.otf \
      $out/share/fonts/opentype

    runHook postInstall
  '';

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
