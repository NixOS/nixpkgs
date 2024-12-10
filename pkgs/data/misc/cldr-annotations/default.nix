{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cldr-annotations";
  version = "45.0";

  src = fetchzip {
    url = "https://unicode.org/Public/cldr/${lib.versions.major version}/cldr-common-${version}.zip";
    stripRoot = false;
    hash = "sha256-8Id9thc3LWSw87aNpuSjQuLmFsx+XvXcz8Ox1Ua3sJw=";
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
    license = licenses.unicode-30;
    platforms = platforms.all;
    maintainers = with maintainers; [ DeeUnderscore ];
  };
}
