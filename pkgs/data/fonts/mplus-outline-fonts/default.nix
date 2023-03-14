{ lib, stdenvNoCC, fetchurl, fetchFromGitHub }:

let pname = "mplus-outline-fonts";
in
{
  osdnRelease = stdenvNoCC.mkDerivation {
    pname = "${pname}-osdn";
    version = "063a";

    src = fetchurl {
      url = "mirror://osdn/mplus-fonts/62344/mplus-TESTFLIGHT-063a.tar.xz";
      hash = "sha256-ROuXO0tq/1dN5FTbEF3cI+Z0nCKUc0vZyx4Nc05M3Xk=";
    };

    installPhase = ''
      runHook preInstall

      install -m444 -Dt $out/share/fonts/truetype/${pname} *.ttf

      runHook postInstall
    '';

    meta = with lib; {
      description = "M+ Outline Fonts (legacy OSDN release)";
      homepage = "https://mplus-fonts.osdn.jp";
      maintainers = with maintainers; [ henrytill uakci ];
      platforms = platforms.all;
      license = licenses.mit;
    };
  };

  githubRelease = stdenvNoCC.mkDerivation {
    pname = "${pname}-github";
    version = "unstable-2022-05-19";

    src = fetchFromGitHub {
      owner = "coz-m";
      repo = "MPLUS_FONTS";
      rev = "336fec4e9e7c1e61bd22b82e6364686121cf3932";
      hash = "sha256-jzDDUs1dKjqNjsMeTA2/4vm+akIisnOuE2mPQS7IDSA=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/{truetype,opentype}/${pname}
      mv fonts/ttf/* $out/share/fonts/truetype/${pname}
      mv fonts/otf/* $out/share/fonts/opentype/${pname}

      runHook postInstall
    '';

    meta = with lib; {
      description = "M+ Outline Fonts (GitHub release)";
      homepage = "https://mplusfonts.github.io";
      maintainers = with maintainers; [ henrytill uakci ];
      platforms = platforms.all;
      license = licenses.ofl;
    };
  };
}
