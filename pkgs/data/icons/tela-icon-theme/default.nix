{ lib, stdenvNoCC, fetchFromGitHub, gtk3, jdupes, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "tela-icon-theme";
  version = "2021-10-08";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-4h6c7asjUC7pqi4GkxCN13LOpVVbjBdvjUMN7sXAlNE=";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

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
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
