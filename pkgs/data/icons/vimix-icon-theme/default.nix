{ lib, stdenv, fetchFromGitHub, gtk3, hicolor-icon-theme, jdupes }:

stdenv.mkDerivation rec {
  pname = "vimix-icon-theme";
  version = "2021-11-09";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "1ali128027yw5kllip7p32c92pby5gaqs0i393m3bp69547np1d4";
  };

  nativeBuildInputs = [ gtk3 jdupes ];

  propagatedBuildInputs = [ hicolor-icon-theme ];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary for this package
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall
    patchShebangs install.sh
    ./install.sh -a -d $out/share/icons
    # replace duplicate files with symlinks
    jdupes -l -r $out/share/icons
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Material Design icon theme based on Paper icon theme";
    homepage = "https://github.com/vinceliuice/vimix-icon-theme";
    license = with licenses; [ cc-by-sa-40 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
