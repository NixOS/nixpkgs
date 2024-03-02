{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "cldr-annotations";
  version = "44.0";

  src = fetchzip {
    url = "https://unicode.org/Public/cldr/${lib.versions.major version}/cldr-common-${version}.zip";
    stripRoot = false;
    hash = "sha256-oK+NlzuRF45laEMJKhNDzr12RF4CHIfDFNBFsIjJh1I=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/unicode/cldr/common
    mv common/annotations{,Derived} -t $out/share/unicode/cldr/common

    runHook postInstall
  '';

  meta = with lib; {
    description = "Names and keywords for Unicode characters from the Common Locale Data Repository";
    homepage = "https://cldr.unicode.org";
    license = licenses.unicode-dfs-2016;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
