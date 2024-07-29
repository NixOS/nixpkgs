{ stdenv
, lib
, fetchurl
, iosevka
, unzip
, variant ? ""
}:

let
  name =
    if lib.hasPrefix "SGr-" variant then variant
    else "Iosevka" + variant;

  variantHashes = import ./variants.nix;
  validVariants = map (lib.removePrefix "Iosevka")
    (builtins.attrNames (builtins.removeAttrs variantHashes [ "Iosevka" ]));
in
stdenv.mkDerivation rec {
  pname = "${name}-bin";
  version = "30.3.3";

  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/PkgTTC-${name}-${version}.zip";
    sha256 = variantHashes.${name} or (throw ''
      No such variant "${variant}" for package iosevka-bin.
      Valid variants are: ${lib.concatStringsSep ", " validVariants}.
    '');
  };

  nativeBuildInputs = [ unzip ];

  dontInstall = true;

  unpackPhase = ''
    mkdir -p $out/share/fonts
    unzip -d $out/share/fonts/truetype $src
  '';

  meta = {
    inherit (iosevka.meta) homepage downloadPage description license platforms;
    maintainers = with lib.maintainers; [
      montchr
    ];
  };

  passthru.updateScript = ./update-bin.sh;
}
