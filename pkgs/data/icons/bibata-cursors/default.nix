{ stdenvNoCC, fetchFromGitHub, gnome-themes-extra, inkscape, xcursorgen, python3 }:

let
  py = python3.withPackages(ps: [ ps.pillow ]);
in stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    sha256 = "1f7i5jkl21fvrr45zpcj40avkc7camjb1ddrrdlaabbplgz5mcgn";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace build.sh --replace "sudo" ""
  '';

  nativeBuildInputs  = [
    gnome-themes-extra
    inkscape
    xcursorgen
    py
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
