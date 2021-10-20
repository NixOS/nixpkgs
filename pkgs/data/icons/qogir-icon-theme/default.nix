{ lib, stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme, jdupes }:

stdenv.mkDerivation rec {
  pname = "qogir-icon-theme";
  version = "2021-10-14";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "0qbbg0hcdda7apk892b8nhbrsvji12nv97ss7lv412xwcmxsj9fp";
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
    name= ./install.sh -d $out/share/icons
    jdupes -l -r $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "Flat colorful design icon theme";
    homepage = "https://github.com/vinceliuice/Qogir-icon-theme";
    license = with licenses; [ gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
