# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:
let name = "undefined-medium-1.0";
in (fetchzip rec {
  inherit name;

  url = "https://github.com/andirueckel/undefined-medium/archive/v1.0.zip";

  sha256 = "1wa04jzbffshwcxm705yb5wja8wakn8j7fvim1mlih2z1sqw0njk";

  meta = with lib; {
    homepage = "https://undefined-medium.com/";
    description = "A pixel grid-based monospace typeface";
    longDescription = ''
      undefined medium is a free and open-source pixel grid-based
      monospace typeface suitable for programming, writing, and
      whatever else you can think of … it’s pretty undefined.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile ${name}/fonts/otf/\*.otf -d $out/share/fonts/opentype
  '';
})
