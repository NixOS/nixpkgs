{stdenv, fetchurl, fontforge, python2}:

let
  inherit (python2.pkgs) fonttools;

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
        homepage = https://pagure.io/liberation-fonts/;
        maintainers = [
          maintainers.raskin
        ];
        platforms = platforms.unix;
      };
    };

in {
  liberation_ttf_v1 = common rec {
    version = "1.07.4";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-${version}.tar.gz";
    sha256 = "01jlg88q2s6by7qv6fmnrlx0lwjarrjrpxv811zjz6f2im4vg65d";
    nativeBuildInputs = [ fontforge ];
    outputHash = "1q102rmg4004p74f8m4y8a6iklmnva0q39sq260jsq3lhcfypg7p";
  };
  liberation_ttf_v2 = common rec {
    version = "2.00.1";
    url = "https://releases.pagure.org/liberation-fonts/liberation-fonts-${version}.tar.gz";
    sha256 = "1ymryvd2nw4jmw4w5y1i3ll2dn48rpkqzlsgv7994lk6qc9cdjvs";
    nativeBuildInputs = [ fontforge fonttools ];
    postPatch = ''
      substituteInPlace scripts/setisFixedPitch-fonttools.py --replace \
        'font = ttLib.TTFont(fontfile)' \
        'font = ttLib.TTFont(fontfile, recalcTimestamp=False)'
    '';
    outputHash = "0nldgawm0a6lpn86w4w3rzx01ns3ph09ar1knq1g4jkxc8ci5rqn";
  };
}
