{ lib, stdenvNoCC, fetchFromGitHub, gtk3, breeze-icons, gnome-icon-theme, numix-icon-theme, numix-icon-theme-circle, hicolor-icon-theme, jdupes }:

stdenvNoCC.mkDerivation rec {
  pname = "zafiro-icons";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "zayronxio";
    repo = pname;
    rev = version;
    sha256 = "sha256-Awc5Sw4X25pXEd4Ob0u6A6Uu0e8FYfwp0fEl90vrsUE=";
  };

  nativeBuildInputs = [
    gtk3
    jdupes
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    numix-icon-theme
    numix-icon-theme-circle
    hicolor-icon-theme
    # still missing parent icon themes: Surfn
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    # remove copy file, as it is there clearly by mistake
    rm "apps/scalable/android-sdk (copia 1).svg"

    mkdir -p $out/share/icons/Zafiro-icons
    cp -a * $out/share/icons/Zafiro-icons

    gtk-update-icon-cache $out/share/icons/Zafiro-icons

    jdupes --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Icon pack flat with light colors";
    homepage = "https://github.com/zayronxio/Zafiro-icons";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
