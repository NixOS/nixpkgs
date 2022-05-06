{ lib, fetchzip }:

let
  version = "40.0";
in fetchzip rec {
  name = "cldr-annotations-${version}";

  url = "https://unicode.org/Public/cldr/40/cldr-common-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/unicode/cldr
    unzip -d $out/share/unicode/cldr $downloadedFile 'common/annotations/*' 'common/annotationsDerived/*'
  '';

  sha256 = "sha256-L4NSMNFYKJWV3qKQhio9eMABtDlLieT9VeMZfzeAkbM=";

  meta = with lib; {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
