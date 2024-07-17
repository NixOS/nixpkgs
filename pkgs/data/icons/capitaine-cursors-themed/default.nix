{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "capitaine-cursors-themed";
  version = "5";

  src = fetchzip {
    url = "https://github.com/sainnhe/capitaine-cursors/releases/download/r${version}/Linux.zip";
    stripRoot = false;
    hash = "sha256-ipPpmZKU/xLA45fdOvxVbtFDCUsCYIvzeps/DjhFkNg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r ./ $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fork of the capitaine cursor theme, with some additional variants (Gruvbox, Nord, Palenight) and support for HiDPI";
    homepage = "https://github.com/sainnhe/capitaine-cursors";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.math-42 ];
  };
}
