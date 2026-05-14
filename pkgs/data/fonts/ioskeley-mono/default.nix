{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
}:

let
  version = "v2.0.0";

  mkFont =
    {
      width,
      variant ? "",
      hash,
      isNF ? false,
      hinted ? true,
    }:
    let
      fileName = "IoskeleyMono${if variant != "" then "-${variant}" else ""}${
        if isNF then "-NerdFont" else ""
      }.zip";
      hintDir = if hinted then "Hinted" else "Unhinted";

      pname =
        let
          wPart = "-${lib.toLower width}";
          vPart = if variant != "" then "-${variant}" else "";
          nfPart = if isNF then "-NF" else "";
          hPart = if !hinted && !isNF then "-unhinted" else "";
        in
        "ioskeley-mono${wPart}${vPart}${nfPart}${hPart}";
    in
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchzip {
        url = "https://github.com/ahatem/IoskeleyMono/releases/download/${version}/${fileName}";
        stripRoot = false;
        inherit hash;
      };

      sourceRoot = if isNF then "source/${width}" else "source/${width}/${hintDir}";

      nativeBuildInputs = [ installFonts ];

      meta = {
        homepage = "https://github.com/ahatem/IoskeleyMono";
        description = "Iosevka configuration mimicking Berkeley Mono, ${width} width${
          if variant != "" then ", ${variant} variant" else ""
        }${if isNF then ", Nerd Font patched" else ""}${if !hinted then ", unhinted" else ""}";
        license = lib.licenses.ofl;
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [ nuexq ];
      };
    };

  allWidths = [
    "Normal"
    "SemiCondensed"
    "Condensed"
  ];

  mkWidths =
    {
      suffix ? "",
      withHinting ? false,
      ...
    }@args:
    let
      mkWidthSet =
        hinted:
        map (w: {
          name = "${lib.strings.toLower (builtins.substring 0 1 w)}${builtins.substring 1 (-1) w}${
            if suffix != "" then "-${suffix}" else ""
          }${if !hinted then "-unhinted" else ""}";

          value = mkFont (
            {
              width = w;
              inherit hinted;
            }
            // (removeAttrs args [
              "suffix"
              "withHinting"
            ])
          );
        }) allWidths;
    in
    lib.listToAttrs (
      if withHinting then
        lib.concatMap (h: mkWidthSet h) [
          true
          false
        ]
      else
        mkWidthSet true
    );
in

# Standard
mkWidths {
  hash = "sha256-EJDlA18XZPq7vhtpw/74n5s1NmTy0/DLu2oYB7OuvbA=";
  withHinting = true;
}

# Term
// mkWidths {
  suffix = "term";
  variant = "Term";
  hash = "sha256-E7I7gmu9EOaCKn4JOFkCjHP/I/1wadRkZoCxVfm+b1k=";
  withHinting = true;
}

// mkWidths {
  suffix = "term-NF";
  variant = "Term";
  isNF = true;
  hash = "sha256-GiMI2YTl20K+zUObcFNzgP1ivm7pH2zHWFG15gFgasg=";
}

# NL
// mkWidths {
  suffix = "NL";
  variant = "NL";
  hash = "sha256-dNOpQJ1VOrjcKS/UtPXKUP9W0gaxFMvH4aa+xK2hg2w=";
  withHinting = true;
}

// mkWidths {
  suffix = "NL-NF";
  variant = "NL";
  isNF = true;
  hash = "sha256-N7mtM/aQwps77u907z8Rop3RftRGR4K8zDXFX8xWq5w=";
}

# Nerd Font Standard
// mkWidths {
  suffix = "NF";
  isNF = true;
  hash = "sha256-Nt8EaVhKvlb9BMKQe4l5iNGcPLzKba6KScIWZbcL8gA=";
}
