{ lib, stdenvNoCC, fetchFromGitHub, gtk3, jdupes, hicolor-icon-theme }:

stdenvNoCC.mkDerivation rec {
  pname = "tela-icon-theme";
<<<<<<< HEAD
  version = "2023-06-25";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "tela-icon-theme";
    rev = version;
    hash = "sha256-tv0C4mW2A3dScUXBWa7a3lkG4lPIjZTsj5b1/oEVuiw=";
=======
  version = "2023-02-03";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    rev = version;
    sha256 = "sha256-W3gGn4ioTg/iOWTa5hfwx6FWzpFilpG8IXwaO5/YAvk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/vinceliuice/Tela-icon-theme/releases/tag/${src.rev}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    # darwin systems use case-insensitive filesystems that cause hash mismatches
    platforms = subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [ figsoda ];
  };
}
