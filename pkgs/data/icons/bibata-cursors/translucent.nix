{ stdenvNoCC, fetchFromGitHub, gnome-themes-extra, inkscape, xcursorgen }:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors-translucent";
  version = "unstable-2019-09-13";
  
  src = fetchFromGitHub {
    owner = "Silicasandwhich";
    repo = "Bibata_Cursor_Translucent";
    rev = "2eed979d817148817ea6bca15c594809aa9c2cb9";
    sha256 = "1s688v40xx9jbvfncb4kgfnnxkmknji7igqx7c4q1ly9s7imbd1f";
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
    description = "Translucent Varient of the Material Based Cursor";
    homepage = https://github.com/Silicasandwhich/Bibata_Cursor_Translucent;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
