{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

let
  makeSuperOTC =
    {
      family,
      description,
      rev,
      hash,
      zip ? "",
      prefix ? "",
    }:
    let
      Family = lib.toUpper (lib.substring 0 1 family) + lib.substring 1 (lib.stringLength family) family;
    in
    stdenvNoCC.mkDerivation rec {
      pname = "source-han-${family}";
      version = lib.removeSuffix "R" rev;

      src = fetchurl {
        url = "https://github.com/adobe-fonts/source-han-${family}/releases/download/${rev}/${prefix}SourceHan${Family}.ttc${zip}";
        inherit hash;
      };

      nativeBuildInputs = lib.optionals (zip == ".zip") [ unzip ];

      unpackPhase =
        lib.optionalString (zip == "") ''
          cp $src SourceHan${Family}.ttc${zip}
        ''
        + lib.optionalString (zip == ".zip") ''
          unzip $src
        '';

      installPhase = ''
        runHook preInstall

        install -Dm444 *.ttc -t $out/share/fonts/opentype/${pname}

        runHook postInstall
      '';

      meta = {
        description = "Open source Pan-CJK ${description} typeface";
        homepage = "https://github.com/adobe-fonts/source-han-${family}";
        license = lib.licenses.ofl;
        maintainers = with lib.maintainers; [
          taku0
          emily
        ];
      };
    };

  makeVariable =
    {
      family,
      version,
      hash,
      format,
    }:
    let
      Family = lib.toUpper (lib.substring 0 1 family) + lib.substring 1 (lib.stringLength family) family;
    in
    fetchurl {
      pname = "source-han-${family}-vf-${format}";
      inherit version hash;
      url = "https://raw.githubusercontent.com/adobe-fonts/source-han-${family}/${version}R/Variable/OTC/SourceHan${Family}-VF.${format}.ttc";
      recursiveHash = true;
      downloadToTemp = true;
      postFetch = "install -Dm444 $downloadedFile $out/share/fonts/variable/SourceHan${Family}-VF.${format}.ttc";

      meta = {
        description = "Open source Pan-CJK ${Family} typeface";
        homepage = "https://github.com/adobe-fonts/source-han-${family}";
        license = lib.licenses.ofl;
        maintainers = with lib.maintainers; [
          taku0
          emily
        ];
      };
    };
in
{
  sans = makeSuperOTC {
    family = "sans";
    description = "sans-serif";
    rev = "2.004R";
    hash = "sha256-b1kRiprdpaf+Tp5rtTgwn34dPFQR+anTKvMqeVAbfk8=";
    zip = ".zip";
  };

  serif = makeSuperOTC {
    family = "serif";
    description = "serif";
    rev = "2.001R";
    hash = "sha256-ULdrtPLtzsgfZEHWkr4ebC/FSROHBWJJVD+PzdIJ6Og=";
    zip = ".zip";
    prefix = "01_";
  };

  mono = makeSuperOTC {
    family = "mono";
    description = "monospaced";
    rev = "1.002";
    hash = "sha256-DBkkSN6QhI8R64M2h2iDqaNtxluJZeSJYAz8x6ZzWME=";
  };

  sans-vf-otf = makeVariable {
    family = "sans";
    version = "2.004";
    hash = "sha256-V7PE09c7h4RDS8Ij4PSI36Gy+LM+PVDi73Rcs+4DfHo=";
    format = "otf";
  };

  sans-vf-ttf = makeVariable {
    family = "sans";
    version = "2.004";
    hash = "sha256-mXTG/d30gUxzxkJpaH4vOawRXMSxxTXlHCvHEsfGqbc=";
    format = "ttf";
  };

  serif-vf-otf = makeVariable {
    family = "serif";
    version = "2.002";
    hash = "sha256-8sD4bU6w7HBm4vBuPAjcjpxN2rtEJugAw+X0bAOcmjA=";
    format = "otf";
  };

  serif-vf-ttf = makeVariable {
    family = "serif";
    version = "2.002";
    hash = "sha256-dmTZFRsD55WCOg2+sqd8bkmTSnSNn5xUYf0PgzIvzww=";
    format = "ttf";
  };
}
