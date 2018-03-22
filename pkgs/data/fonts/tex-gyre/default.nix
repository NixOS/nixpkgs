{ stdenv, fetchzip }:

let
  mkVariant = variant: { displayName, version, abbreviation, sha256, outputHash }: stdenv.mkDerivation {
    name = "tex-gyre-${variant}-${version}";
    inherit version;

    src = fetchzip {
      url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/${variant}/${abbreviation}${version}otf.zip";
      stripRoot = false;
      inherit sha256;
    };

    installPhase = ''
      mkdir -p $out/share/fonts/opentype/
      cp -v *.otf $out/share/fonts/opentype/
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = outputHash;

    meta = with stdenv.lib; {
      homepage = http://www.gust.org.pl/projects/e-foundry/tex-gyre;
      # "The TeX Gyre fonts are licensed under the GUST Font License (GFL),
      # which is a free license, legally equivalent to the LaTeX Project Public
      # License (LPPL), version 1.3c or later." - GUST website
      license = licenses.lppl13c;
      maintainers = with maintainers; [ jtojnar ];
      platforms = platforms.all;
    };
  };
in stdenv.lib.mapAttrs mkVariant {
  adventor = {
    displayName = "Adventor";
    version = "2.003";
    sha256 = "13wnb04z9f766ij30x8bpkn4xzv7n466g07dlbimx7qvglxl605g";
    outputHash = "1cz0lkk2a5fg8r8175h454va499hzln3s99dadxhh147nx1914pm";
    abbreviation = "qag";
  };
  bonum = {
    displayName = "Bonum";
    version = "2.004";
    sha256 = "0qbrs98knx4h0b297c5n3vav4mkal1a95ai2dzmdc10pghfzl8vv";
    outputHash = "0bid8gzwz50ylmm8jyqf9s4nfvy6cp1x34wbyrh4gyk1ki6hf3z1";
    abbreviation = "qbk";
  };
  chorus = {
    displayName = "Chorus";
    version = "2.003";
    sha256 = "1b0zak27fzmapwbf2jasvsd95vhnqyc92n985d1lc1ivwja1zgfa";
    outputHash = "0fqifd45c1ys6y98b66lmldfbv7wjb2414fs9swicv4n7xvl3cp1";
    abbreviation = "qzc";
  };
  cursor = {
    displayName = "Cursor";
    version = "2.004";
    sha256 = "0ck3jm33bk2xsxp5d2irzd3j24zb49f0gnjvd1nikg1ivk8w85ng";
    outputHash = "0i76835xqlkrnlx303mx63m0f4899j056c2ag2fl6p9qk8s4rskp";
    abbreviation = "qcr";
  };
  heros = {
    displayName = "Heros";
    version = "2.004";
    sha256 = "1fj2srxxf6ap913y5yd3dn4jzg828j7381gifs39nm5lnzmgw78y";
    outputHash = "16y76ab46fxm9k8wfmwx4w0cl96yrmjywz587lyr08s0agp1v3kf";
    abbreviation = "qhv";
  };
  pagella = {
    displayName = "Pagella";
    version ="2.004";
    sha256 = "0b2pjhw1ihnl951slln6d6vafjd3i6p4i947lwybvg8081qfvd9z";
    outputHash = "0c6s0r14qax3b4amvm9nffwzby8mm4p7r2hfb8yv9jzhjwa5z8rd";
    abbreviation = "qpl";
  };
  schola = {
    displayName = "Schola";
    version = "2.005";
    sha256 = "05z3gk4mm0sa7wwjcv31j2xlzqhwhcncpamn0kn9y0221cdknyp8";
    outputHash = "1yqq1ngcylhldrh1v35l439k72szq9m4gx6g0wh235fk65chb2bm";
    abbreviation = "qcs";
  };
  termes = {
    displayName = "Termes";
    version = "2.004";
    sha256 = "1aq3yqbgkc3z20dkcqyhicsyq0afbgg4l397z96sd8a16jyz2x8k";
    outputHash = "1igw821m601h8937pix6yish4d8fxmz3h4j9hripf41bxsiafzzg";
    abbreviation = "qtm";
  };
}
