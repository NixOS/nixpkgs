{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation rec {
  pname = "vimix-cursor-theme";
  version = "2020-02-24";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Vimix-cursors";
    rev = version;
    hash = "sha256-TfcDer85+UOtDMJVZJQr81dDy4ekjYgEvH1RE1IHMi4=";
  };

  installPhase = ''
    sed -i 's/Vimix Cursors$/Vimix-Cursors/g' dist{,-white}/index.theme

    install -dm 755 $out/share/icons/Vimix-Cursors{,-White}

    cp -dr --no-preserve='ownership' dist/*        $out/share/icons/Vimix-Cursors
    cp -dr --no-preserve='ownership' dist-white/*  $out/share/icons/Vimix-Cursors-White
  '';

  meta = with lib; {
    description = "An x-cursor theme inspired by Materia design and based on capitaine-cursors";
    homepage = "https://github.com/vinceliuice/Vimix-cursors";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ redxtech ];
  };
}
