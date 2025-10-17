{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  breeze-icons,
  elementary-icon-theme,
  gnome-icon-theme,
  hicolor-icon-theme,
}:

stdenvNoCC.mkDerivation rec {
  pname = "la-capitaine-icon-theme";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "keeferrourke";
    repo = "la-capitaine-icon-theme";
    rev = "v${version}";
    sha256 = "0id2dddx6rl71472l47vafx968wnklmq6b980br68w82kcvqczzs";
  };

  propagatedBuildInputs = [
    breeze-icons
    elementary-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postPatch = ''
    patchShebangs configure

    substituteInPlace configure \
      --replace 'DISTRO=$(format "$(lsb_release -si 2>/dev/null)")' 'DISTRO=nixos'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/$pname
    cp -a * $out/share/icons/$pname
    rm $out/share/icons/$pname/{configure,COPYING,LICENSE,*.md}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Icon theme inspired by macOS and Google's Material Design";
    homepage = "https://github.com/keeferrourke/la-capitaine-icon-theme";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
