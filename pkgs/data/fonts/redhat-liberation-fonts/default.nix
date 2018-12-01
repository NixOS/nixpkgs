{stdenv, fetchurl, fontforge, python3}:

let
  inherit (python3.pkgs) fonttools;

  common =
    {version, url, sha256, nativeBuildInputs, postPatch ? null, outputHash}:
    stdenv.mkDerivation rec {
      name = "liberation-fonts-${version}";
      src = fetchurl {
        inherit url sha256;
      };

      inherit nativeBuildInputs postPatch;

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -v $( find . -name '*.ttf') $out/share/fonts/truetype

        mkdir -p "$out/share/doc/${name}"
        cp -v AUTHORS ChangeLog COPYING License.txt README "$out/share/doc/${name}" || true
      '';

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      inherit outputHash;

      meta = with stdenv.lib; {
        description = "Liberation Fonts, replacements for Times New Roman, Arial, and Courier New";
        longDescription = ''
          The Liberation Fonts are intended to be replacements for the three most
          commonly used fonts on Microsoft systems: Times New Roman, Arial, and
          Courier New. Since 2012 they are based on croscore fonts.

          There are three sets: Sans (a substitute for Arial, Albany, Helvetica,
          Nimbus Sans L, and Bitstream Vera Sans), Serif (a substitute for Times
          New Roman, Thorndale, Nimbus Roman, and Bitstream Vera Serif) and Mono
          (a substitute for Courier New, Cumberland, Courier, Nimbus Mono L, and
          Bitstream Vera Sans Mono).
        '';

        license = licenses.ofl;
        homepage = https://github.com/liberationfonts;
        maintainers = [
          maintainers.raskin
        ];
        platforms = platforms.unix;
      };
    };

in {
  liberation_ttf_v1_from_source = common rec {
    version = "1.07.5";
    url = https://github.com/liberationfonts/liberation-1.7-fonts/files/2175696/liberation-fonts-1.07.5.tar.gz;
    sha256 = "0k1p2nrbx5vjs93x6z91z8y6nkn1vv1zncd02kp9v0ghf0ddmsaa";
    nativeBuildInputs = [ fontforge ];
    outputHash = "16jn17p22z2vip58aza2dfg1ri31ki6z3hsnmidfqfi7v8k83vq4";
  };
  liberation_ttf_v1_binary = common rec {
    version = "1.07.5";
    url = https://github.com/liberationfonts/liberation-1.7-fonts/files/2175699/liberation-fonts-ttf-1.07.5.tar.gz;
    sha256 = "0wx999dx83azjqrz56pldnan41k8g12zrccg15j5nqhg7k6687r0";
    nativeBuildInputs = [ ];
    outputHash = "1spdwjlswylhl89yz35fnrin55n68hyx82laglicnhwwxv2vapg2";
  };
  liberation_ttf_v2_from_source = common rec {
    version = "2.00.4";
    url = https://github.com/liberationfonts/liberation-fonts/files/2579282/liberation-fonts-2.00.4.tar.gz;
    sha256 = "13f5c5q0kim3l1v2l4v2wqyfhl4fb4c27yq77zpyl7hnm5kfqicl";
    nativeBuildInputs = [ fontforge fonttools ];
    postPatch = ''
      substituteInPlace scripts/setisFixedPitch-fonttools.py --replace \
        'font = ttLib.TTFont(fontfile)' \
        'font = ttLib.TTFont(fontfile, recalcTimestamp=False)'
    '';
    outputHash = "14c0c5n4vzd5y0hf9jkh48h12kkd8hlg94npbmv41j449g6wv6vn";
  };
  liberation_ttf_v2_binary = common rec {
    version = "2.00.4";
    url = https://github.com/liberationfonts/liberation-fonts/files/2579281/liberation-fonts-ttf-2.00.4.tar.gz;
    sha256 = "0ifz9b6dd3rdx47f0lsjvk3jnkhiq6py4njnpva77jqfbvy9a3n4";
    nativeBuildInputs = [ ];
    outputHash = "0946hqjrb4qlvfgr909zv44bzrs2wyz7v24nz2f5flh25s9bmyzd";
  };
}
