{ lib, fetchzip }:

fetchzip rec {
  pname = "cldr-annotations";
  version = "42.0";

  url = "https://unicode.org/Public/cldr/${lib.versions.major version}/cldr-common-${version}.zip";

  stripRoot = false;
  postFetch = ''
    mkdir -p $out/share/unicode/cldr/common
    mv $out/common/annotations{,Derived} -t $out/share/unicode/cldr/common

    shopt -s extglob dotglob
    rm -rf $out/!(share)
    shopt -u extglob dotglob
  '';

  hash = "sha256-9OOd69nBaDSt+ilL3PTGpcQgC60PnHqd8/CYa2LgeI0=";

  meta = with lib; {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
