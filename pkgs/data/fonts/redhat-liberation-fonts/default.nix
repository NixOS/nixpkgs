{ stdenv, fetchFromGitHub, fontforge, python3 }:

let
  inherit (python3.pkgs) fonttools;

  common =
    { version, repo, sha256, nativeBuildInputs, postPatch ? null, outputHash }:
    stdenv.mkDerivation rec {
      pname = "liberation-fonts";
      inherit version;

      src = fetchFromGitHub {
        owner = "liberationfonts";
        rev = version;
        inherit repo sha256;
      };

      inherit nativeBuildInputs postPatch;

      installPhase = ''
        mkdir -p $out/share/fonts/truetype
        cp -v $( find . -name '*.ttf') $out/share/fonts/truetype

        mkdir -p "$out/share/doc/${pname}-${version}"
        cp -v AUTHORS ChangeLog COPYING License.txt README "$out/share/doc/${pname}-${version}" || true
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
  liberation_ttf_v1 = common rec {
    repo = "liberation-1.7-fonts";
    version = "1.07.5";
    nativeBuildInputs = [ fontforge ];
    sha256 = "1ffl10mf78hx598sy9qr5m6q2b8n3mpnsj73bwixnd4985gsz56v";
    outputHash = "16jn17p22z2vip58aza2dfg1ri31ki6z3hsnmidfqfi7v8k83vq4";
  };
  liberation_ttf_v2 = common rec {
    repo = "liberation-fonts";
    version = "2.00.4";
    nativeBuildInputs = [ fontforge fonttools ];
    postPatch = ''
      substituteInPlace scripts/setisFixedPitch-fonttools.py --replace \
        'font = ttLib.TTFont(fontfile)' \
        'font = ttLib.TTFont(fontfile, recalcTimestamp=False)'
    '';
    sha256 = "14bn1zlhyr4qaz5z2sx4h115pnbd41ix1vky8fxm2lx76xrjjiaa";
    outputHash = "14c0c5n4vzd5y0hf9jkh48h12kkd8hlg94npbmv41j449g6wv6vn";
  };
}
