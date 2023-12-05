{
  stdenvNoCC
, lib
, fetchFromGitHub
, symlinkJoin
}: let
  version = "unstable-2023-07-22";

  arimoSpec = {
    name = "arimo";
    rev = "302dc85954f887248b4ad442b0966e4ead1c1cf9";
    hash = "sha256-Z9CVdiWPHla7ybkNXx2z7xr+jvv5SCeo2dU7U8K9IMs=";
    longDescription = "A free font metric-compatible with Arial.";
    license = lib.licenses.asl20;
  };

  tinosSpec = {
    name = "tinos";
    rev = "ba5282d4706054e82332d3863ac96e069b34f032";
    hash = "sha256-vxPFAoMGkL9WReFRyUUFxQ18KyAuzGzkOKOQ6On8zlo=";
    longDescription = "A free font metric-compatible with Times New Roman.";
  };

  cousineSpec = {
    name = "cousine";
    rev = "134dfbb9d26045ab76936f9cb9d169ef6ff743f0";
    hash = "sha256-01ShGv3poLMI+DvpS0DFSuvhWYppC8pTvjQD28hQ4xk=";
    longDescription = "A free font metric-compatible with Courier New.";
  };

  carlitoSpec = {
    name = "carlito";
    rev = "3a810cab78ebd6e2e4eed42af9e8453c4f9b850a";
    hash = "sha256-U4TvZZ7n7dr1/14oZkF1Eo96ZcdWIDWron70um77w+E=";
    longDescription = "A free font metric-compatible with Calibri.";
  };

  roboto-flexSpec = {
    name = "roboto-flex";
    rev = "739e06dc46ebb14cddd88b9768a6c1504d4677f6";
    hash = "sha256-/FdsA+Qvx9oGUdk/XurZJNARJkvDX6LgjBU40wAllL8=";
    longDescription = "Roboto Flex is a variable font version of Roboto," +
      " Google's signature font family. It is a sans serif typeface" +
      " intended to work well in user interfaces.";
  };

  open-sansSpec = {
    name = "open-sans";
    repo = "opensans";
    rev = "52bd0a97bdc86a8e913600d6f748a90d870c3e7c";
    hash = "sha256-yiJsvH0Ocdjjj5MvXHe7E/R0jfAIbAti5c3Z/QmWu5k=";
    longDescription = ''
      Variable font originally designed by Steve Matteson of Ascender
      Hebrew by Yanek Iontef
      Weight expansion by Micah Stupak
      Help and advice from Meir Sadan and Marc Foley
    '';
  };

  oswaldSpec = {
    name = "oswald";
    repo = "oswaldfont";
    rev = "6e65651c229e897dc55fb8d17097ee7f75b2769b";
    hash = "sha256-4RNJLaOzcIjPGUVnImK5Ngoi5+XKuQaqZy0S4uUCKGM=";
    longDescription = "Oswald is a reworking of the classic gothic typeface" +
      " style historically represented by designs such as 'Franklyn Gothic'" +
      " , 'Alternate Gothic', 'News Gothic' and more. The characters of" +
      " Oswald have been re-drawn and reformed to better fit the pixel grid" +
      " of standard digital screens. Oswald is designed to be used freely" +
      " across the internet by web browsers on desktop computers, laptops" +
      " and mobile devices.";
  };

  michromaSpec = {
    name = "michroma";
    repo = "michroma-font";
    rev = "07893d1b85a537a6ed4b96fdb091bee45eabe65f";
    hash = "sha256-EGe2VnlPmwQ2P49iqUbnc7n5jsPKYGuOVfOLBH97A2Y=";
    longDescription = "Michroma is a reworking and remodelling of the" +
      " rounded-square sans genre that is closely associated with a 1960s" +
      " feeling of the future. This is due to the popularity of " +
      " Microgramma, designed by Aldo Novarese and Alessandro Buttiin in" +
      " 1952, which pioneered the style; and the most famous typeface " +
      " family of the genre that came 10 years later in Novarese's Eurostile.";
  };

  nunitoSpec = {
    name = "nunito";
    rev = "43d16f963c5c341c10efa0bfe7a82aa1bea8a938";
    hash = "sha256-9Ap+WaUd5chxS4cJbT86aTopKOvNpNsFawnx1h5HwDw=";
    longDescription = "Nunito is a well balanced Sans Serif with rounded" +
      " terminals. Nunito has been designed mainly to be used as a display" +
      " font but is useable as a text font too. Nunito has been designed to" +
      " be used freely across the internet by web browsers on desktop" +
      " computers, laptops and mobile devices.";
  };

  mkFont = (font: let inherit ({
      # defaults that are overridden with `font` attributes
      inherit (font) name;  # `name` is the only required attr
      repo = name;
      longDescription = "A Google font.";
      license = lib.licenses.ofl;
      rev = "main";
      hash = "";
    } // font) name repo longDescription license rev hash;
    in stdenvNoCC.mkDerivation {
      inherit version;
      pname = "googlefonts." + name;

      src = fetchFromGitHub {
        inherit repo rev hash;
        owner = "googlefonts";
        sparseCheckout = [ "/fonts/" ];
      } + "/fonts/";

      dontBuild = true;
      dontConfigure = true;
      installPhase = ''
        set -e ; shopt -u nullglob

        local out_font=$out/share/fonts/googlefonts/

        if [ -d ttf/variable_ttf ]; then
          f=ttf/variable_ttf/
        elif [ -d variable ]; then
          f=variable/
        elif [ -d vf  ]; then
          f=vf/
        elif [ -d otf ]; then
          f=otf/
        elif [ -d ttf ]; then
          f=ttf/
        elif ls *.ttf || ls *.otf ; then
          f=./
        else
          echo "no precompiled fonts found"
          exit 1
        fi

        echo "Installing ${name} from $f"

        if [ -d "$f"unhinted/variable_ttf ]; then
          install -m444 -Dt $out_font "$f"unhinted/variable_ttf/*.ttf
        elif [ -d "$f"unhinted/otf ]; then
          install -m444 -Dt $out_font "$f"unhinted/otf/*.otf
        elif [ -d "$f"unhinted/ttf ]; then
          install -m444 -Dt $out_font "$f"unhinted/ttf/*.ttf
        elif ls "$f"*.ttf &>/dev/null; then
          install -m444 -Dt $out_font "$f"*.ttf
        elif ls "$f"*.otf &>/dev/null; then
          install -m444 -Dt $out_font "$f"*.otf
        else
          echo "no fonts found in $f"
          exit 1
        fi || {
          echo "something went very wrong, probably a bug in the script."
          exit 1
        }
      '';

      meta = with lib; {
        inherit longDescription license;
        description = "A free font created or forked by Google";
        homepage = "https://github.com/googlefonts";
        platforms = platforms.all;
        maintainers = [ maintainers.janw4ld ];
      };
    });

  mkFontPack = { fontList, name, description }: with lib; let
      getMetaAttr = attr: (map (f: f.meta."${attr}") fontList);
      foldl1 = fn: l: foldl fn (head l) (tail l);
    in (symlinkJoin {
      name = "googlefonts.${name}-${version}";
      paths = fontList;
    }).overrideAttrs {
      meta = {
        inherit description;
        license =  unique (getMetaAttr "license");
        platforms = foldl1 intersectLists (getMetaAttr "platforms");
        maintainers = unique (getMetaAttr "maintainers");
      };
    };
in rec {
  croscorePack = mkFontPack {
    name = "croscorePack";
    description =  "A pack of fonts metric-compatible with Arial," +
      " Times New Roman, Courier New and Calibri";
    fontList = [ arimo tinos cousine carlito ];
  };
  arimo = mkFont arimoSpec;
  tinos = mkFont tinosSpec;
  cousine = mkFont cousineSpec;
  carlito = mkFont carlitoSpec;
  roboto-flex = mkFont roboto-flexSpec;
  open-sans = mkFont open-sansSpec;
  oswald = mkFont oswaldSpec;
  michroma = mkFont michromaSpec;
  nunito = mkFont nunitoSpec;
}
