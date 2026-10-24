{
  lib,
  stdenv,
  fetchzip,
  installFonts,
}:

let
  mkVariant =
    variant:
    {
      version,
      abbreviation,
      sha256,
      outputHash,
    }:
    stdenv.mkDerivation {
      pname = "tex-gyre-${variant}";
      inherit version;

      src = fetchzip {
        url = "https://www.gust.org.pl/projects/e-foundry/tex-gyre/${variant}/${abbreviation}${version}otf.zip";
        stripRoot = false;
        inherit sha256;
      };

      nativeBuildInputs = [
        installFonts
      ];

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      inherit outputHash;

      meta = {
        homepage = "http://www.gust.org.pl/projects/e-foundry/tex-gyre";
        # "The TeX Gyre fonts are licensed under the GUST Font License (GFL),
        # which is a free license, legally equivalent to the LaTeX Project Public
        # License (LPPL), version 1.3c or later." - GUST website
        license = lib.licenses.lppl13c;
        maintainers = [ ];
        platforms = lib.platforms.all;
      };
    };
in
lib.mapAttrs mkVariant {
  adventor = {
    version = "2_501";
    sha256 = "0qjg3x0adfppyx3x33cm07ww9i9sl88xaq07m7wfip8rmyp567fn";
    outputHash = "sha256-RyzIrpjw524UlaGumPYtFDI5Z8EoqeDIIiWHKoAz8IQ=";
    abbreviation = "qag";
  };
  bonum = {
    version = "2.004";
    sha256 = "0qbrs98knx4h0b297c5n3vav4mkal1a95ai2dzmdc10pghfzl8vv";
    outputHash = "sha256-4Q8HTZxh+kdg9ouT0cNlxm9niU4Oe4lqpR6Uz/9DLS4=";
    abbreviation = "qbk";
  };
  chorus = {
    version = "2.003";
    sha256 = "1b0zak27fzmapwbf2jasvsd95vhnqyc92n985d1lc1ivwja1zgfa";
    outputHash = "sha256-4bJBdz+WbBa5TtqRQMSS/OzlGq3UmIWSN9oHVkhzETs=";
    abbreviation = "qzc";
  };
  cursor = {
    version = "2.004";
    sha256 = "0ck3jm33bk2xsxp5d2irzd3j24zb49f0gnjvd1nikg1ivk8w85ng";
    outputHash = "sha256-d+pMNJo4XUOdeEowU4BMCREH6jC9DjA6tXlS3MtA5kQ=";
    abbreviation = "qcr";
  };
  heros = {
    version = "2.004";
    sha256 = "1fj2srxxf6ap913y5yd3dn4jzg828j7381gifs39nm5lnzmgw78y";
    outputHash = "sha256-bo4d7lNAI5A9Pah87mXN3iTKACedV8fRTLU7Q5Yyx5s=";
    abbreviation = "qhv";
  };
  pagella = {
    version = "2_501";
    sha256 = "1kccaxs3vk93la2pz4nv05hx1x3diyla49cz4l33zifdcp2zgg9d";
    outputHash = "sha256-SGEkQ8/ShgJPJ732vnUYfaTndk6hzStASQLWSO/T0to=";
    abbreviation = "qpl";
  };
  schola = {
    version = "2.005";
    sha256 = "05z3gk4mm0sa7wwjcv31j2xlzqhwhcncpamn0kn9y0221cdknyp8";
    outputHash = "sha256-dYkFWTHTlSEgB8/0R2rCX4sz0yC0jB1gbhRSz54NGPs=";
    abbreviation = "qcs";
  };
  termes = {
    version = "2.004";
    sha256 = "1aq3yqbgkc3z20dkcqyhicsyq0afbgg4l397z96sd8a16jyz2x8k";
    outputHash = "sha256-73+nou4rEHdjhkkSOH7tDjUCdfSmx3tGQjAAU4NA/MU=";
    abbreviation = "qtm";
  };
}
