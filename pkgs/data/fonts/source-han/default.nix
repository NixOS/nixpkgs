{ stdenvNoCC
, lib
, fetchzip
, fetchurl
}:

let
  makePackage = { family, description, rev, sha256 }: let
    Family =
      lib.toUpper (lib.substring 0 1 family) +
      lib.substring 1 (lib.stringLength family) family;

    ttc = fetchurl {
      url = "https://github.com/adobe-fonts/source-han-${family}/releases/download/${rev}/SourceHan${Family}.ttc";
      inherit sha256;
    };
  in stdenvNoCC.mkDerivation {
    pname = "source-han-${family}";
    version = lib.removeSuffix "R" rev;

    buildCommand = ''
      install -m444 -Dt $out/share/fonts/opentype/source-han-${family} ${ttc}
    '';

    meta = {
      description = "An open source Pan-CJK ${description} typeface";
      homepage = "https://github.com/adobe-fonts/source-han-${family}";
      license = lib.licenses.ofl;
      maintainers = with lib.maintainers; [ taku0 emily ];
    };
  };
in
{
  sans = let
    rev = "2.004R";
    family = "sans";
    Family = "Sans";
    zip = fetchzip {
      url = "https://github.com/adobe-fonts/source-han-${family}/releases/download/${rev}/SourceHan${Family}.ttc.zip";
      stripRoot = false;
      sha256 = "0z852kzb84vqk57icfaxbfxhf43awcn8w39byfypxaxigzhy78l7";
    };
  in stdenvNoCC.mkDerivation {
    pname = "source-han-sans";
    version = lib.removeSuffix "R" rev;

    buildCommand = ''
      install -m444 -Dt $out/share/fonts/opentype/source-han-sans ${zip}/SourceHanSans.ttc
    '';

    meta = {
      description = "An open source Pan-CJK sans-serif typeface";
      homepage = "https://github.com/adobe-fonts/source-han-${family}";
      license = lib.licenses.ofl;
      maintainers = with lib.maintainers; [ taku0 emily ];
    };
  };

  serif = makePackage {
    family = "serif";
    description = "serif";
    rev = "1.001R";
    sha256 = "1d968h30qvvwy3s77m9y3f1glq8zlr6bnfw00yinqa18l97n7k45";
  };

  mono = makePackage {
    family = "mono";
    description = "monospaced";
    rev = "1.002";
    sha256 = "1haqffkcgz0cc24y8rc9bg36v8x9hdl8fdl3xc8qz14hvr42868c";
  };
}
