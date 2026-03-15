{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

let
  version = "2025.10.09-6";

  mkFont =
    {
      variant,
      suffix,
      hash,
    }:
    stdenvNoCC.mkDerivation {
      pname = "ioskeley-mono-${variant}";
      inherit version;

      src = fetchzip {
        url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/IoskeleyMono-TTF-${suffix}.zip";
        stripRoot = false;
        inherit hash;
      };

      nativeBuildInputs = [ installFonts ];

      fontDirectories = [ "TTF" ];

      meta = {
        homepage = "https://github.com/ahatem/IoskeleyMono";
        description = "Iosevka configuration to mimic the look and feel of Berkeley Mono as closely as possible (${variant} version)";
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ nuexq ];
      };
    };
in
{
  hinted = mkFont {
    variant = "hinted";
    suffix = "Hinted";
    hash = "sha256-LoauAQE3wR75skP00KvsYcRZqkraVsSTqbCQl7UFRJ0=";
  };

  unhinted = mkFont {
    variant = "unhinted";
    suffix = "Unhinted";
    hash = "sha256-XMoVTvH2nu2WMmzUZp9mkvBwvd7VJJ0N3YPB02hhzss=";
  };
}
