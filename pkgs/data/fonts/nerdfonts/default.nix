{
  stdenv,
  fetchurl,
  lib,
  # To select only certain fonts, put a list of strings to `fonts`: every key in
  # ./shas.nix is an optional font
  fonts ? [ ],
  # Whether to enable Windows font variants, their internal font name is limited
  # to 31 characters
  enableWindowsFonts ? false,
}:

let
  # both of these files are generated via ./update.sh
  version = import ./version.nix;
  fontsShas = import ./shas.nix;
  knownFonts = builtins.attrNames fontsShas;
  selectedFonts =
    if (fonts == [ ]) then
      knownFonts
    else
      let
        unknown = lib.subtractLists knownFonts fonts;
      in
      if (unknown != [ ]) then throw "Unknown font(s): ${lib.concatStringsSep " " unknown}" else fonts;
  selectedFontsShas = lib.attrsets.genAttrs selectedFonts (fName: fontsShas."${fName}");
  srcs = lib.attrsets.mapAttrsToList (
    fName: fSha:
    (fetchurl {
      url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${fName}.tar.xz";
      sha256 = fSha;
    })
  ) selectedFontsShas;
in

stdenv.mkDerivation (finalAttrs: {
  inherit version;
  inherit srcs;
  pname = "nerdfonts";
  sourceRoot = ".";
  buildPhase = ''
    echo "selected fonts are ${toString selectedFonts}"
    ls *.otf *.ttf
  '';
  installPhase = ''
    find -name \*.otf -exec mkdir -p $out/share/fonts/opentype/NerdFonts \; -exec mv {} $out/share/fonts/opentype/NerdFonts \;
    find -name \*.ttf -exec mkdir -p $out/share/fonts/truetype/NerdFonts \; -exec mv {} $out/share/fonts/truetype/NerdFonts \;
    ${lib.optionalString (!enableWindowsFonts) ''
      rm -rfv $out/share/fonts/opentype/NerdFonts/*Windows\ Compatible.*
      rm -rfv $out/share/fonts/truetype/NerdFonts/*Windows\ Compatible.*
    ''}
  '';
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Iconic font aggregator, collection, & patcher. 3,600+ icons, 50+ patched fonts";
    longDescription = ''
      Nerd Fonts is a project that attempts to patch as many developer targeted
      and/or used fonts as possible. The patch is to specifically add a high
      number of additional glyphs from popular 'iconic fonts' such as Font
      Awesome, Devicons, Octicons, and others.
    '';
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
    hydraPlatforms = [ ]; # 'Output limit exceeded' on Hydra
  };
})
