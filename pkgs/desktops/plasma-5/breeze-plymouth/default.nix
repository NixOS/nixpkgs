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
  # these will typically need to be set via an override
  # in a NixOS context
  nixosBranding ? false,
  nixosName ? "NixOS",
  nixosVersion ? "",
  topColor ? "black",
  bottomColor ? "black"
}:

let
  logoName = "nixos";
in
mkDerivation {
  name = "breeze-plymouth";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ plymouth ] ++ lib.optionals nixosBranding [ imagemagick netpbm perl ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  cmakeFlags = lib.optionals nixosBranding [
    "-DDISTRO_NAME=${nixosName}"
    "-DDISTRO_VERSION=${nixosVersion}"
    "-DDISTRO_LOGO=${logoName}"
    "-DBACKGROUND_TOP_COLOR=${topColor}"
    "-DBACKGROUND_BOTTOM_COLOR=${bottomColor}"
  ];
  postPatch = ''
      substituteInPlace cmake/FindPlymouth.cmake --subst-var out
  '' + lib.optionalString nixosBranding ''
      cp ${nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png breeze/images/${logoName}.logo.png

      # conversion for 16bit taken from the breeze-plymouth readme
      convert ${nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png -alpha Background -background "#000000" -fill "#000000" -flatten tmp.png
      pngtopnm tmp.png | pnmquant 16 | pnmtopng > breeze/images/16bit/${logoName}.logo.png
  '';
}
