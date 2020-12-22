{ stdenv, lib, fetchurl, iosevka, unzip
, variant ? ""
}:

let
  name = "iosevka" + lib.optionalString (variant != "") "-" + variant;

  variantHashes = import ./variants.nix;
  validVariants = map (lib.removePrefix "iosevka-")
    (builtins.attrNames (builtins.removeAttrs variantHashes [ "iosevka" ]));
in stdenv.mkDerivation rec {
  pname = "${name}-bin";
  version = "4.1.1";

  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/ttc-${name}-${version}.zip";
    sha256 = variantHashes.${name} or (throw ''
      No such variant "${variant}" for package iosevka-bin.
      Valid variants are: ${lib.concatStringsSep ", " validVariants}.
    '');
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" ];

  unpackPhase = ''
    mkdir -p $out/share/fonts
    unzip -d $out/share/fonts/truetype $src
  '';

  meta = iosevka.meta // {
    maintainers = with lib.maintainers; [
      cstrahan
    ];
  };

  passthru.updateScript = ./update-bin.sh;
}
