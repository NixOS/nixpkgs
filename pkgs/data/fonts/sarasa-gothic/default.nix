{ lib, fetchurl, libarchive }:

let
  version = "0.37.0";
in fetchurl {
  name = "sarasa-gothic-${version}";

  # Use the 'ttc' files here for a smaller closure size.
  # (Using 'ttf' files gives a closure size about 15x larger, as of November 2021.)
  url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${version}/sarasa-gothic-ttc-${version}.7z";
  sha256 = "sha256-R1vU17PSfOe2w9PutA7zYrNsa4mejbXqWlWQVV5KXqs=";

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
