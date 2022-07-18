{ lib, fetchzip }:

let
  version = "41.0";
in fetchzip rec {
  name = "cldr-annotations-${version}";

  url = "https://unicode.org/Public/cldr/${lib.versions.major version}/cldr-common-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/unicode/cldr
    unzip -d $out/share/unicode/cldr $downloadedFile 'common/annotations/*' 'common/annotationsDerived/*'
  '';

  sha256 = "sha256-3dHVZGx3FmR97fzhlTSx/xp6YTAV+sMExl6gpLzl1MY=";

  meta = with lib; {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
