{ stdenv, fetchurl, p7zip }:

let
  version = "0.6.0";
  sha256 = "08g3kzplp3v8kvni1vzl73fgh03xgfl8pwqyj7vwjihjdr1xfjyz";
in fetchurl rec {
  inherit sha256;

  name = "sarasa-gothic-${version}";

  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile
    mkdir -p $out/share/fonts
    install -m644 *.ttc $out/share/fonts/
  '';

  meta = with stdenv.lib; {
    description = "SARASA GOTHIC is a Chinese & Japanese programming font based on Iosevka and Source Han Sans";
    homepage = https://github.com/be5invis/Sarasa-Gothic;
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
  };
}
