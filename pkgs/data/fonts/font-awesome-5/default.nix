{ lib, fetchFromGitHub }:
let
  font-awesome = { version, sha256, rev ? version}: fetchFromGitHub rec {
    name = "font-awesome-${version}";


    owner = "FortAwesome";
    repo = "Font-Awesome";
    inherit rev;

    postFetch = ''
      tar xf $downloadedFile --strip=1
      install -m444 -Dt $out/share/fonts/opentype {fonts,otfs}/*.otf
    '';

    inherit sha256;

    meta = with lib; {
      description = "Font Awesome - OTF font";
      longDescription = ''
        Font Awesome gives you scalable vector icons that can instantly be customized.
        This package includes only the OTF font. For full CSS etc. see the project website.
      '';
      homepage = "http://fortawesome.github.io/Font-Awesome/";
      license = licenses.ofl;
      platforms = platforms.all;
      maintainers = with maintainers; [ abaldeau johnazoidberg ];
    };
  };
in {
  # Keeping version 4 because version 5 is incompatible for some icons. That
  # means that projects which depend on it need to actively convert the
  # symbols. See:
  # https://github.com/greshake/i3status-rust/issues/130
  # https://fontawesome.com/how-to-use/on-the-web/setup/upgrading-from-version-4
  v4 = font-awesome {
    version = "4.7.0";
    rev = "v4.7.0";
    sha256 = "1j8i32dq6rrlv3kf2hnq81iqks06kczaxjks7nw3zyq1231winm9";
  };
  v5 = font-awesome {
    version = "5.10.2";
    sha256 = "0bg28zn2lhrcyj7mbavphkvw3hrbnjsnn84305ax93nj3qd0d4hx";
  };
}
