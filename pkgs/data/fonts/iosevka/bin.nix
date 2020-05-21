{ stdenv, lib, fetchurl, unzip
, variant ? ""
}:

let
  name = "iosevka" + lib.optionalString (variant != "") "-" + variant;

  variantHashes = import ./variants.nix;
  validVariants = map (lib.removePrefix "iosevka-")
    (builtins.attrNames (builtins.removeAttrs variantHashes [ "iosevka" ]));
in stdenv.mkDerivation rec {
  pname = "${name}-bin";
  version = "3.7.1";

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

  meta = with lib; {
    homepage = "https://be5invis.github.io/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.cstrahan ];
  };

  passthru.updateScript = ./update.sh;
}
