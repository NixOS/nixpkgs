# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let
  version = "unstable-2018-09-11";
in
(fetchzip {
  name = "times-newer-roman-${version}";

  url = "https://web.archive.org/web/20210609022835/https://timesnewerroman.com/assets/TimesNewerRoman.zip";

  hash = "sha256-Hx59RYLLwfimEQjEEes0lCpg6iql46DFwhQ7kVGiEzc=";

  meta = with lib; {
    description = "A font that looks just like Times New Roman, except each character is 5-10% wider";
    homepage = "https://timesnewerroman.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';
})
