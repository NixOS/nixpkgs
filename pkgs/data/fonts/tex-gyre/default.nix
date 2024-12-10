{
  lib,
  stdenv,
  fetchzip,
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
      name = "tex-gyre-${variant}-${version}";
      inherit version;

      src = fetchzip {
        url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/${variant}/${abbreviation}${version}otf.zip";
        stripRoot = false;
        inherit sha256;
      };

      installPhase = ''
        mkdir -p $out/share/fonts/opentype/
        # Pagella & Adventor are not flat archives
        test -d "${abbreviation}${version}otf" && cd "${abbreviation}${version}otf"
        cp -v *.otf $out/share/fonts/opentype/
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      inherit outputHash;

      meta = with lib; {
        homepage = "http://www.gust.org.pl/projects/e-foundry/tex-gyre";
        # "The TeX Gyre fonts are licensed under the GUST Font License (GFL),
        # which is a free license, legally equivalent to the LaTeX Project Public
        # License (LPPL), version 1.3c or later." - GUST website
        license = licenses.lppl13c;
        maintainers = with maintainers; [ ];
        platforms = platforms.all;
      };
    };
in
lib.mapAttrs mkVariant {
  adventor = {
    version = "2_501";
    sha256 = "0qjg3x0adfppyx3x33cm07ww9i9sl88xaq07m7wfip8rmyp567fn";
    outputHash = "117h6f02m1r54b4f1a98q5kkjchl5pv9ibm1jla6xrzhk2pchb27";
    abbreviation = "qag";
  };
  bonum = {
    version = "2.004";
    sha256 = "0qbrs98knx4h0b297c5n3vav4mkal1a95ai2dzmdc10pghfzl8vv";
    outputHash = "0bid8gzwz50ylmm8jyqf9s4nfvy6cp1x34wbyrh4gyk1ki6hf3z1";
    abbreviation = "qbk";
  };
  chorus = {
    version = "2.003";
    sha256 = "1b0zak27fzmapwbf2jasvsd95vhnqyc92n985d1lc1ivwja1zgfa";
    outputHash = "0fqifd45c1ys6y98b66lmldfbv7wjb2414fs9swicv4n7xvl3cp1";
    abbreviation = "qzc";
  };
  cursor = {
    version = "2.004";
    sha256 = "0ck3jm33bk2xsxp5d2irzd3j24zb49f0gnjvd1nikg1ivk8w85ng";
    outputHash = "0i76835xqlkrnlx303mx63m0f4899j056c2ag2fl6p9qk8s4rskp";
    abbreviation = "qcr";
  };
  heros = {
    version = "2.004";
    sha256 = "1fj2srxxf6ap913y5yd3dn4jzg828j7381gifs39nm5lnzmgw78y";
    outputHash = "16y76ab46fxm9k8wfmwx4w0cl96yrmjywz587lyr08s0agp1v3kf";
    abbreviation = "qhv";
  };
  pagella = {
    version = "2_501";
    sha256 = "1kccaxs3vk93la2pz4nv05hx1x3diyla49cz4l33zifdcp2zgg9d";
    outputHash = "1nnjsgplimh29502pkd19rvfg93x31svxxmx4x7h51njrx1j8qa8";
    abbreviation = "qpl";
  };
  schola = {
    version = "2.005";
    sha256 = "05z3gk4mm0sa7wwjcv31j2xlzqhwhcncpamn0kn9y0221cdknyp8";
    outputHash = "1yqq1ngcylhldrh1v35l439k72szq9m4gx6g0wh235fk65chb2bm";
    abbreviation = "qcs";
  };
  termes = {
    version = "2.004";
    sha256 = "1aq3yqbgkc3z20dkcqyhicsyq0afbgg4l397z96sd8a16jyz2x8k";
    outputHash = "1igw821m601h8937pix6yish4d8fxmz3h4j9hripf41bxsiafzzg";
    abbreviation = "qtm";
  };
}
