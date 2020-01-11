{ stdenvNoCC, fetchFromGitHub, gnome-themes-extra, inkscape, xcursorgen }:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    sha256 = "14gvpjp4gv0m59qr8wls7xs5yjx5llldyzack5kg5cg2mzk2nsml";
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
    description = "Material Based Cursor";
    homepage = https://github.com/KaizIqbal/Bibata_Cursor;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rawkode ];
  };
}
