{ stdenvNoCC
, lib
, fetchzip
}:

let
  makePackage =
    { family
    , description
    , rev
    , sha256
    , postFetch ? ''
        install -m444 -Dt $out/share/fonts/opentype/source-han-${family} $downloadedFile
      ''
    , zip ? ""
    }:
    let Family =
      lib.toUpper (lib.substring 0 1 family) +
      lib.substring 1 (lib.stringLength family) family;
    in
    fetchzip {
      name = "source-han-${family}-${lib.removeSuffix "R" rev}";

      url = "https://github.com/adobe-fonts/source-han-${family}/releases/download/${rev}/SourceHan${Family}.ttc${zip}";
      inherit sha256 postFetch;

      meta = {
        description = "An open source Pan-CJK ${description} typeface";
        homepage = "https://github.com/adobe-fonts/source-han-${family}";
        license = lib.licenses.ofl;
        maintainers = with lib.maintainers; [ taku0 emily ];
      };
    };
in
{
  sans = makePackage {
    family = "sans";
    description = "sans-serif";
    rev = "2.004R";
    sha256 = "052d17hvz435zc4r2y1p9cgkkgn0ps8g74mfbvnbm1pv8ykj40m9";
    postFetch = ''
      mkdir -p $out/share/fonts/opentype/source-han-sans
      unzip $downloadedFile -d $out/share/fonts/opentype/source-han-sans
    '';
    zip = ".zip";
  };

  serif = makePackage {
    family = "serif";
    description = "serif";
    rev = "2.000R";
    sha256 = "0x3n6s4khdd6l0crwd7g9sjaqp8lkvksglhc7kj3cv80hldab9wp";
    postFetch = ''
      mkdir -p $out/share/fonts/opentype/source-han-serif
      unzip $downloadedFile -d $out/share/fonts/opentype/source-han-serif
    '';
    zip = ".zip";
  };

  mono = makePackage {
    family = "mono";
    description = "monospaced";
    rev = "1.002";
    sha256 = "010h1y469c21bjavwdmkpbwk3ny686inz8i062wh1dhcv8cnqk3c";
  };
}
