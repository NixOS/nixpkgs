{ lib, fetchzip, fetchFromGitHub }:

let pname = "mplus-outline-fonts";
in {
  osdnRelease = fetchzip {
    name = "${pname}-osdn";
    url = "mirror://osdn/mplus-fonts/62344/mplus-TESTFLIGHT-063a.tar.xz";
    sha256 = "16jirhkjs46ac8cdk2w4xkpv989gmz7i8gnrq9bck13rbil7wlzr";
    postFetch = ''
      mkdir -p $out/share/fonts/truetype/${pname}
      tar xvJf $downloadedFile
      mv */*.ttf $out/share/fonts/truetype/${pname}
    '';

    meta = with lib; {
      description = "M+ Outline Fonts (legacy OSDN release)";
      homepage = "https://mplus-fonts.osdn.jp";
      maintainers = with maintainers; [ henrytill uakci ];
      platforms = platforms.all;
      license = licenses.mit;
    };
  };

  githubRelease = fetchFromGitHub {
    name = "${pname}-github";
    owner = "coz-m";
    repo = "MPLUS_FONTS";
    rev = "336fec4e9e7c1e61bd22b82e6364686121cf3932";
    sha256 = "1ha92hyzcfbbq682c50k8clbhigc09rcb9mxjzjwqfj9rfp348id";
    postFetch = ''
      mkdir -p $out/share/fonts/{truetype,opentype}/${pname}
      tar xvzf $downloadedFile
      mv */fonts/ttf/* $out/share/fonts/truetype/${pname}
      mv */fonts/otf/* $out/share/fonts/opentype/${pname}
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
