{ lib, fetchurl, libarchive }:

let
  version = "0.36.8";
in fetchurl {
  name = "sarasa-gothic-${version}";

  # Use the 'ttc' files here for a smaller closure size.
  # (Using 'ttf' files gives a closure size about 15x larger, as of November 2021.)
  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "sha256-lKrpaTVYmV3wr1Uj5Yqj1p1t0CYF0ApX7j+QFNfpdz0=";

  recursiveHash = true;
  downloadToTemp = true;

  postFetch = ''
    mkdir -p $out/share/fonts/truetype
    ${libarchive}/bin/bsdtar -xf $downloadedFile -C $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "A CJK programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = licenses.ofl;
    maintainers = [ maintainers.ChengCat ];
    platforms = platforms.all;
  };
}
