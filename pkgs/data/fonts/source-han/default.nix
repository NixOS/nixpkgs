{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

let
  makePackage =
    { family
    , description
    , rev
    , hash
    , zip ? ""
    }:
    let Family =
      lib.toUpper (lib.substring 0 1 family) +
      lib.substring 1 (lib.stringLength family) family;
    in
    stdenvNoCC.mkDerivation rec {
      pname = "source-han-${family}";
      version = lib.removeSuffix "R" rev;

      src = fetchurl {
        url = "https://github.com/adobe-fonts/source-han-${family}/releases/download/${rev}/SourceHan${Family}.ttc${zip}";
        inherit hash;
      };

      nativeBuildInputs = lib.optionals (zip == ".zip") [ unzip ];

      unpackPhase = lib.optionalString (zip == "") ''
        cp $src SourceHan${Family}.ttc${zip}
      '' + lib.optionalString (zip == ".zip") ''
        unzip $src
      '';

      installPhase = ''
        runHook preInstall

        install -Dm444 *.ttc -t $out/share/fonts/opentype/${pname}

        runHook postInstall
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
  sans = makePackage {
    family = "sans";
    description = "sans-serif";
    rev = "2.004R";
    hash = "sha256-b1kRiprdpaf+Tp5rtTgwn34dPFQR+anTKvMqeVAbfk8=";
    zip = ".zip";
  };

  serif = makePackage {
    family = "serif";
    description = "serif";
    rev = "2.000R";
    hash = "sha256-RDgywab7gwT+YBO7F1KJvKOv0E/3+7Zi/pQl+UDsGcM=";
    zip = ".zip";
  };

  mono = makePackage {
    family = "mono";
    description = "monospaced";
    rev = "1.002";
    hash = "sha256-DBkkSN6QhI8R64M2h2iDqaNtxluJZeSJYAz8x6ZzWME=";
  };
}
