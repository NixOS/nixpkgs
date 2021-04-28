{ fetchFromGitHub, gtk3, hicolor-icon-theme, jdupes, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tela-icon-theme";
  version = "2021-01-21";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0gphy4aq2qjcg79k6rc0q5901mn3q76qhckn5vxvmypn9n3lb9ph";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  installPhase = ''
    runHook preInstall
    patchShebangs install.sh
    mkdir -p $out/share/icons
    ./install.sh -a -d $out/share/icons
    jdupes -l -r $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "A flat colorful Design icon theme";
    homepage = "https://github.com/vinceliuice/tela-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
