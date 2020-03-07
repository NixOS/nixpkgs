{
  mkDerivation,
  lib,
  copyPathsToStore,
  extra-cmake-modules,
  plymouth,
  nixos-icons,
  imagemagick,
  netpbm,
  perl,
  logoName ? null,
  logoFile ? null,
  osName ? null,
  osVersion ? null,
  topColor ? "black",
  bottomColor ? "black"
}:

let 
  validColors = [ "black" "cardboard_grey" "charcoal_grey" "icon_blue" "paper_white" "plasma_blue" "neon_blue" "neon_green" ];
  resolvedLogoName = if (logoFile != null && logoName == null) then lib.strings.removeSuffix ".png" (baseNameOf(toString logoFile)) else logoName;
in
  assert lib.asserts.assertOneOf "topColor" topColor validColors;
  assert lib.asserts.assertOneOf "bottomColor" bottomColor validColors;
  

mkDerivation {
  name = "breeze-plymouth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plymouth ] ++ lib.optionals (logoFile != null) [ imagemagick netpbm perl ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  cmakeFlags = []
    ++ lib.optional (osName      != null) "-DDISTRO_NAME=${osName}"
    ++ lib.optional (osVersion   != null) "-DDISTRO_VERSION=${osVersion}"
    ++ lib.optional (logoName    != null) "-DDISTRO_LOGO=${logoName}"
    ++ lib.optional (topColor    != null) "-DBACKGROUND_TOP_COLOR=${topColor}"
    ++ lib.optional (bottomColor != null) "-DBACKGROUND_BOTTOM_COLOR=${bottomColor}"
  ;
  
  postPatch = ''
      substituteInPlace cmake/FindPlymouth.cmake --subst-var out
  '' + lib.optionalString (logoFile != null) ''
      cp ${logoFile} breeze/images/${resolvedLogoName}.logo.png

      # conversion for 16bit taken from the breeze-plymouth readme
      convert ${logoFile} -alpha Background -background "#000000" -fill "#000000" -flatten tmp.png
      pngtopnm tmp.png | pnmquant 16 | pnmtopng > breeze/images/16bit/${resolvedLogoName}.logo.png
  '';
}
