{ lib, fetchzip }:

let
  version = "6.0.0";

in fetchzip {
  name = "ibm-plex-${version}";

  url = "https://github.com/IBM/plex/releases/download/v${version}/OpenType.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile "OpenType/*/*.otf" -x "OpenType/IBM-Plex-Sans-JP/unhinted/*" -d $out/share/fonts/opentype
  '';

  sha256 = "0zv9kw4hmchf374pl0iajzybmx5wklsplg56j115m46i4spij6mr";

  meta = with lib; {
    description = "IBM Plex Typeface";
    homepage = "https://www.ibm.com/plex/";
    changelog = "https://github.com/IBM/plex/raw/v${version}/CHANGELOG.md";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.romildo ];
  };
}
