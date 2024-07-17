{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "times-newer-roman";
  version = "unstable-2018-09-11";

  src = fetchzip {
    url = "https://web.archive.org/web/20210609022835/https://timesnewerroman.com/assets/TimesNewerRoman.zip";
    stripRoot = false;
    hash = "sha256-wO4rxyJNQyhRLpswCYKXdeiXy5G+iWyxulYCHZb60QM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype
    cp *.otf $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A font that looks just like Times New Roman, except each character is 5-10% wider";
    homepage = "https://timesnewerroman.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
