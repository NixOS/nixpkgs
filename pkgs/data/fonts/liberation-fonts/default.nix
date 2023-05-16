{ lib, stdenv, fetchFromGitHub, fontforge, python3 }:
let
  inherit (python3.pkgs) fonttools;

  commonNativeBuildInputs = [ fontforge python3 ];
  common =
<<<<<<< HEAD
    { version, repo, sha256, docsToInstall, nativeBuildInputs, postPatch ? null }:
=======
    { version, repo, sha256, nativeBuildInputs, postPatch ? null }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
          find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/truetype {} \;

<<<<<<< HEAD
          for i in ${toString docsToInstall}; do
            # not all docs exist in all versions
            install -m444 -Dt $out/share/doc/${pname}-${version} $i || true
          done
=======
          install -m444 -Dt $out/share/doc/${pname}-${version} AUTHORS     || true
          install -m444 -Dt $out/share/doc/${pname}-${version} ChangeLog   || true
          install -m444 -Dt $out/share/doc/${pname}-${version} COPYING     || true
          install -m444 -Dt $out/share/doc/${pname}-${version} License.txt || true
          install -m444 -Dt $out/share/doc/${pname}-${version} README      || true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        '';

        meta = with lib; {
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
          homepage = "https://github.com/liberationfonts";
          maintainers = with maintainers; [ raskin ];
        };
      };
in
{
  liberation_ttf_v1 = common {
    repo = "liberation-1.7-fonts";
    version = "1.07.5";
<<<<<<< HEAD
    docsToInstall = [ "AUTHORS" "ChangeLog" "COPYING" "License.txt" "README" ];
    nativeBuildInputs = commonNativeBuildInputs;
=======
    nativeBuildInputs = commonNativeBuildInputs ;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "1ffl10mf78hx598sy9qr5m6q2b8n3mpnsj73bwixnd4985gsz56v";
  };
  liberation_ttf_v2 = common {
    repo = "liberation-fonts";
<<<<<<< HEAD
    version = "2.1.5";
    docsToInstall = [ "AUTHORS" "ChangeLog" "LICENSE" "README.md" ];
=======
    version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    nativeBuildInputs = commonNativeBuildInputs ++ [ fonttools ];
    postPatch = ''
      substituteInPlace scripts/setisFixedPitch-fonttools.py --replace \
        'font = ttLib.TTFont(fontfile)' \
        'font = ttLib.TTFont(fontfile, recalcTimestamp=False)'
    '';
<<<<<<< HEAD
    sha256 = "Wg1uoD2k/69Wn6XU+7wHqf2KO/bt4y7pwgmG7+IUh4Q=";
=======
    sha256 = "03xpzaas264x5n6qisxkhc68pkpn32m7y78qdm3rdkxdwi8mv8mz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
