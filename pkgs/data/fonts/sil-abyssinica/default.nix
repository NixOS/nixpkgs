{ fetchzip, lib }:

let
  version = "2.100";
in
fetchzip rec {
  name = "sil-abyssinica-${version}";
  url = "https://software.sil.org/downloads/r/abyssinica/AbyssinicaSIL-${version}.zip";
  sha256 = "sha256-06olbIdSlhJ4hgblzzabqIs57FpsyWIdPDFXb9vK31A=";

  postFetch = ''
    rm -rf $out/web
    mkdir -p $out/share/{fonts/truetype,doc/${name}}
    mv $out/*.ttf $out/share/fonts/truetype/
    mv $out/*.txt $out/documentation $out/share/doc/${name}/
  '';

  meta = with lib; {
    description = "Unicode font for Ethiopian and Erythrean scripts (Amharic et al.)";
    homepage = "https://software.sil.org/abyssinica/";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
