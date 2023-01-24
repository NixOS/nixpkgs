{ fetchzip, lib }:

let
  version = "5.001";
in
fetchzip rec {
  name = "sil-padauk-${version}";
  url = "https://software.sil.org/downloads/r/padauk/Padauk-${version}.zip";
  sha256 = "sha256-6H9EDmXr1Ox2fgLw9sG5JrCAllK3tbjvMfLi8DTF1f0=";

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    rm -rf $out/{manifest.json,web/}
    mv $out/*.ttf $out/share/fonts/truetype/
    mkdir -p $out/share/doc/${name}
    mv $out/*.txt $out/documentation/ $out/share/doc/${name}/
  '';

  meta = with lib; {
    description = "A Unicode-based font family with broad support for writing systems that use the Myanmar script";
    homepage = "https://software.sil.org/padauk";
    license = licenses.ofl;
    maintainers = with maintainers; [ serge ];
    platforms = platforms.all;
  };
}
