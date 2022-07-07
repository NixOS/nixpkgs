{ lib, fetchzip, fetchFromGitHub }:

let pname = "mplus-outline-fonts";
in {
  osdnRelease = fetchzip {
    name = "${pname}-osdn";
    url = "mirror://osdn/mplus-fonts/62344/mplus-TESTFLIGHT-063a.tar.xz";
    sha256 = "sha256-+VN+aFx5hMlWwtk+FM+vL6G07+yEi9kYYsoQLSfMUZo=";
    postFetch = ''
      install -m444 -Dt $out/share/fonts/truetype/${pname} $out/*.ttf
      shopt -s extglob dotglob
      rm -rf $out/!(share)
      shopt -u extglob dotglob
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
    sha256 = "sha256-LSIyrstJOszll72mxXIC7EW4KEMTFCaQwWs59j0UScE=";
    postFetch = ''
      mkdir -p $out/share/fonts/{truetype,opentype}/${pname}
      mv $out/fonts/ttf/* $out/share/fonts/truetype/${pname}
      mv $out/fonts/otf/* $out/share/fonts/opentype/${pname}
      shopt -s extglob dotglob
      rm -rf $out/!(share)
      shopt -u extglob dotglob
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
