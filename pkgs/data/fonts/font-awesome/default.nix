{ lib, fetchFromGitHub }:
let
  font-awesome = { version, sha256, rev ? version }: fetchFromGitHub {
    name = "font-awesome-${version}";


    owner = "FortAwesome";
    repo = "Font-Awesome";
    inherit rev;

    postFetch = ''
      install -m444 -Dt $out/share/fonts/opentype $out/{fonts,otfs}/*.otf
      shopt -s extglob dotglob
      rm -rf $out/!(share)
      shopt -u extglob dotglob
    '';

    inherit sha256;

    meta = with lib; {
      description = "Font Awesome - OTF font";
      longDescription = ''
        Font Awesome gives you scalable vector icons that can instantly be customized.
        This package includes only the OTF font. For full CSS etc. see the project website.
      '';
      homepage = "https://fontawesome.com/";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [ abaldeau johnazoidberg ];
    };
  };
in
{
  # Keeping version 4 and 5 because version 6 is incompatible for some icons. That
  # means that projects which depend on it need to actively convert the
  # symbols. See:
  # https://github.com/greshake/i3status-rust/issues/130
  # https://fontawesome.com/how-to-use/on-the-web/setup/upgrading-from-version-4
  # https://fontawesome.com/v6/docs/web/setup/upgrade/
  v4 = font-awesome {
    version = "4.7.0";
    rev = "v4.7.0";
    sha256 = "sha256-qdrIwxAB+z+4PXrKrj6bBuiJY0DYQuHm2DRng5sYEck=";
  };
  v5 = font-awesome {
    version = "5.15.3";
    sha256 = "sha256-EDxk/yO3nMmtM/ytrAEgPYSBbep3rA3NrKkiqf3OsU0=";
  };
  v6 = font-awesome {
    version = "6.1.1";
    sha256 = "sha256-BjK1PJQFWtKDvfQ2Vh7BoOPqYucyvOG+2Pu/Kh+JpAA=";
  };
}
