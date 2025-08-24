{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  sources = {
    babelstone-pseudographica = {
      fontName = "BabelStone Pseudographica";
      formats = {
        truetype = {
          url = "https://babelstone.co.uk/Fonts/Download/BabelStonePseudographica.ttf";
          hash = "sha256-9rQvhXps7Yv0H95Tpj8os5v4Ttrxu0C4xg/G7FkUMI4=";
        };
        woff = {
          url = "https://babelstone.co.uk/Fonts/WOFF/BabelStonePseudographica.woff";
          hash = "sha256-SUglR97dgPXtkV065IIw9He007Hu1fGJcxxUtuEP0iU=";
        };
        woff2 = {
          url = "https://babelstone.co.uk/Fonts/WOFF/BabelStonePseudographica.woff2";
          hash = "sha256-w2H7tuGZ7+r/WHe9rUAgugtxh1UdJ0IK1Xp+eEYrH2Q=";
        };
      };
    };

    babelstone-pseudographica-colour = {
      fontName = "BabelStone Pseudographica Colour";
      formats = {
        truetype = {
          url = "https://babelstone.co.uk/Fonts/Download/BabelStonePseudographicaColour.ttf";
          hash = "sha256-sqy9AzrFqaxvuAz4eLmufbOJLo60zunUJHdP9YUl8vM=";
        };
        woff = {
          url = "https://babelstone.co.uk/Fonts/WOFF/BabelStonePseudographicaColour.woff";
          hash = "sha256-cJ0eSWMxAI8qLOmjwT5TnruXqCvsbhsP7VAwA5o3aag=";
        };
        woff2 = {
          url = "https://babelstone.co.uk/Fonts/WOFF/BabelStonePseudographicaColour.woff2";
          hash = "sha256-cQmcA1n6YeeGll9f/R6zZRrRIgxQIEXpF3v4Zd1kde0=";
        };
      };
    };
  };

  mkBabelstonePseudographica =
    {
      pname,
      fontName ? pname,
      url,
      hash,
      format,
    }:
    stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "${pname}-${format}";
      version = "16.0.0";

      phases = [
        "installPhase"
      ];

      src = fetchurl {
        inherit url hash;
      };

      installPhase = ''
        runHook preInstall

        install -Dm644 ${finalAttrs.src} -t $out/share/fonts/${format}

        runHook postInstall
      '';

      meta = {
        description = "${fontName} is a font covering various geometric shapes (${format})";
        homepage = "https://babelstone.co.uk/Fonts/Pseudographica.html";

        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ theobori ];
      };
    });
in
lib.mapAttrs (
  pname: fontAttr:
  lib.mapAttrs (
    format: src:
    mkBabelstonePseudographica (
      {
        inherit pname format;
        inherit (fontAttr) fontName;
      }
      // src
    )
  ) fontAttr.formats
) sources
