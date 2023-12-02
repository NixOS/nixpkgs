{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vimix-cursor-theme";
  version = "2020-02-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Vimix-cursors";
    rev = finalAttrs.version;
    sha256 = "sha256-TfcDer85+UOtDMJVZJQr81dDy4ekjYgEvH1RE1IHMi4=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Vimix{,-white}-cursors
    cp -r dist/{cursors,index.theme} $out/share/icons/Vimix-cursors
    cp -r dist-white/{cursors,index.theme} $out/share/icons/Vimix-white-cursors
    runHook postInstall
  '';

  meta = with lib; {
    description = "An x-cursor theme inspired by Materia design and based on caitaine-cursors";
    homepage = "https://github.com/vinceliuice/Vimix-cursors";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      bryceberger
    ];
  };
})
