{ stdenv, fetchzip }:

let
  variants = {
    bonum = {
      displayName = "Bonum";
      version = "1.005";
      sha256 = "1b6x7siypyxp1lhq7xxdqafwbn6p2p3xm3jb38q999sv8cgslxz8";
      outputHash = "1zjaxkzidqmxakh9d61n0by9mi8hrmir45jppjj6hzwhm3rvknff";
    };
    pagella = {
      displayName = "Pagella";
      version = "1.632";
      sha256 = "0f4cgq9w0lc1fbcbfqiv19mdhivbsscl13jmb0ln685641ci2sjr";
      outputHash = "0wz2n1dpx9b8a0qgqy8vl712fxhi87mhcda281xaad62chndwf6k";
    };
    schola = {
      displayName = "Schola";
      version = "1.533";
      sha256 = "0caqgkz7gz700h5a1mai0gq8hv7skrgs5nnrs1f7zw1mb9g53ya9";
      outputHash = "0jk4bpxki95a9lmfj4cgpnv1jwlkh8qixbkf498n1x7hkaz03f5n";
    };
    termes = {
      displayName = "Termes";
      version = "1.543";
      sha256 = "10ayqfpryfn1l35hy0vwyjzw3a6mfsnzgf78vsnccgk2gz1g9vhz";
      outputHash = "0pa433cgshlypbyrrlp3qq0wg972rngcp37pr8pxdfshgz13q1mm";
    };
  };

  mkVariant = variant: current:
    let dotless_version = builtins.replaceStrings ["."] [""] current.version; in
    stdenv.mkDerivation rec {
      name = "tex-gyre-${variant}-math-${current.version}";
      version = "${current.version}";

      src = fetchzip {
        url = "www.gust.org.pl/projects/e-foundry/tg-math/download/texgyre${variant}-math-${dotless_version}.zip";
        sha256 = current.sha256;
      };

      installPhase = ''
        mkdir -p $out/share/fonts/opentype/
        mkdir -p $out/share/doc/${name}/
        cp -v opentype/*.otf $out/share/fonts/opentype/
        cp -v doc/*.txt $out/share/doc/${name}/
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      outputHash = current.outputHash;

      meta = with stdenv.lib; {
        longDescription = ''
          TeX Gyre ${current.displayName} Math is a math companion for the TeX Gyre
          ${current.displayName} family of fonts (see
          http://www.gust.org.pl/projects/e-foundry/tex-gyre/) in the OpenType format.
        '';
        homepage = http://www.gust.org.pl/projects/e-foundry/tg-math;
        # "The TeX Gyre Math fonts are licensed under the GUST Font License (GFL),
        # which is a free license, legally equivalent to the LaTeX Project Public
        # License (LPPL), version 1.3c or later." - GUST website
        license = licenses.lppl13c;
        maintainers = with maintainers; [ siddharthist ];
        platforms = platforms.all;
      };
    };
in
  stdenv.lib.mapAttrs mkVariant variants
