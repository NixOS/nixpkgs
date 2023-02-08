{ lib
, stdenvNoCC
, fetchurl
}:

/*
# Adobe Blank is split out in a separate output,
# because it causes crashes with `libfontconfig`.
# It has an absurd number of symbols
outputs = [ "out" "adobeBlank" ];
*/

let
  #version = "";
  rev = "a7ca44cdf53d8597ac7425b67ac6ca5fa74177b7";

  # TODO use a more lightweight builder?
  mkFont = fontName: license: files: stdenvNoCC.mkDerivation rec {
    name = "google-fonts-${fontName}";
    # no version to avoid rebuilds
    # TODO add versions to srcs.nix - font version, not repo version
    srcs = map (sha256_url: fetchurl {
      url = "https://github.com/google/fonts/raw/${rev}/${builtins.elemAt sha256_url 1}";
      sha256 = builtins.elemAt sha256_url 0;
    }) files;
    buildCommand = ''
      urldecode() {
        local s="''${1//+/ }"
        printf '%b' "''${s//%/\x}"
      }
      mkdir -p $out/share/fonts/truetype
      ${builtins.concatStringsSep "\n" (map (src: ''
        cp -v ${src} $out/share/fonts/truetype/$(basename $(urldecode '${src.url}'))
      '') srcs)}
    '';
    meta = with lib; {
      #homepage = "https://fonts.google.com";
      #description = "Font files available from Google Fonts"; # obvious from pname
      license = licenses.${license};
      platforms = platforms.all; # default?
      hydraPlatforms = [];
      #maintainers = with maintainers; [ manveru ]; # .maintainers is overrated ...
    };
  };
in

(import ./srcs.nix { inherit mkFont; })
