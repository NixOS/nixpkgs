{ lib, fetchzip }:
fetchzip rec {
  pname = "capitaine-cursors-themed";
  version = "5";
  stripRoot = false;
  url = "https://github.com/sainnhe/capitaine-cursors/releases/download/r${version}/Linux.zip";
  sha256 = "jQNAXuR/OtvohWziGYgb5Ni2/tEIGaY9HIyUUW793EY=";

  postFetch = ''
    mkdir -p $out/share/icons
    cp -r ./ $out/share/icons
  '';

  meta = with lib; {
    description = "A fork of the capitaine cursor theme, with some additional variants (Gruvbox, Nord, Palenight) and support for HiDPI";
    homepage = "https://github.com/sainnhe/capitaine-cursors";
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.math-42 ];
  };
}
