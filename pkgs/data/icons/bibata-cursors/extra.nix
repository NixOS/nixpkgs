{ stdenvNoCC, fetchFromGitHub, gnome-themes-extra, inkscape, xcursorgen }:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-extra-cursors";
  version = "unstable-2018-10-28";
  
  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Extra_Cursor";
    rev = "66fb64b8dbe830e3f7ba2c2bdc4dacae7c438789";
    sha256 = "1xb7v06sbxbwzd7cnghv9c55lpbbkcaf1nswdrqy87gd0bnpdd2n";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace build.sh --replace "gksu " ""
  '';

  nativeBuildInputs  = [
    gnome-themes-extra
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    HOME="$NIX_BUILD_ROOT" ./build.sh
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cp -pr Bibata_* $out/share/icons/
  '';

  meta = with stdenvNoCC.lib; {
    description = "Cursors Based on Bibata";
    homepage = https://github.com/KaizIqbal/Bibata_Extra_Cursor;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
