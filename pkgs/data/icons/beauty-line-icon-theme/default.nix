{ lib
, stdenvNoCC
, fetchFromGitHub
, breeze-icons
, gtk3
, gnome-icon-theme
, hicolor-icon-theme
, mint-x-icons
, pantheon
, jdupes
}:

stdenvNoCC.mkDerivation rec {
  pname = "BeautyLine";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "gvolpe";
    repo = pname;
    rev = version;
    sparseCheckout = ''
      BeautyLine-V3
    '';
    sha256 = "sha256-IkkypAj250+OXbf19TampCnqYsSbJVIjeYlxJoyhpzk=";
  };

  sourceRoot = "${src.name}/BeautyLine-V3";

  nativeBuildInputs = [ jdupes gtk3 ];

  # ubuntu-mono is also required but missing in ubuntu-themes (please add it if it is packaged at some point)
  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    hicolor-icon-theme
    mint-x-icons
    pantheon.elementary-icon-theme
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/${pname}
    cp -r * $out/share/icons/${pname}/
    gtk-update-icon-cache $out/share/icons/${pname}

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "BeautyLine icon theme";
    homepage = "https://www.gnome-look.org/p/1425426/";
    platforms = platforms.linux;
    license = [ licenses.publicDomain ];
    maintainers = with maintainers; [ gvolpe ];
  };
}
