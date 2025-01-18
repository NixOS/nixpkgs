{
  stdenvNoCC,
  lib,
  fetchurl,
  variants ? [ ],
}:

let
  sources = import ./sources.nix;
  knownVariants = builtins.attrNames sources;
  selectedVariants =
    if (variants == [ ]) then
      knownVariants
    else
      let
        unknownVariants = lib.subtractLists knownVariants variants;
      in
      if (unknownVariants != [ ]) then
        throw "Unknown variant(s): ${lib.concatStringsSep unknownVariants}"
      else
        variants;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xcursor-pro";
  version = "2.0.2";
  srcs = map (variant: fetchurl { inherit (sources.${variant}) url sha256; }) selectedVariants;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    for theme in XCursor-Pro-{${lib.concatStringsSep "," selectedVariants}}; do
      mkdir -p $out/share/icons/$theme/cursors
      cp -a $theme/cursors/* $out/share/icons/$theme/cursors/
      install -m644 $theme/index.theme $out/share/icons/$theme/index.theme
    done

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/ful1e5/XCursor-pro";
    description = "Modern XCursors";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      lactose
      midirhee12
    ];
  };
})
