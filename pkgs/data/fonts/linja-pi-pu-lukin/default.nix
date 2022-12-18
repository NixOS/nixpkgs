{ lib, fetchurl }:

fetchurl {
  pname = "linja-pi-pu-lukin";
  version = "unstable-2021-10-29";

  url = "https://web.archive.org/web/20211029000000/https://jansa-tp.github.io/linja-pi-pu-lukin/PuLukin.otf";
  hash = "sha256-VPdrMHWpiokFYON4S8zT+pSs4TsB17S8TZRtkjqIqU8=";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/share/fonts/opentype/linja-pi-pu-lukin.otf
  '';

  meta = with lib; {
    description = "A sitelen pona font resembling the style found in Toki Pona: The Language of Good (lipu pu), by jan Sa.";
    homepage = "https://jansa-tp.github.io/linja-pi-pu-lukin/";
    license = licenses.unfree; # license is unspecified in repository
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
