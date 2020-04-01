{ stdenvNoCC, fetchFromGitHub, gnome-themes-extra, inkscape, xcursorgen, python3 }:

let
  py = python3.withPackages(ps: [ ps.pillow ]);
in stdenvNoCC.mkDerivation rec {
  pname = "bibata-extra-cursors";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "KaizIqbal";
    repo = "Bibata_Extra_Cursor";
    rev = "v${version}";
    sha256 = "1bh945hvakbh985jkr6g6x0myw3k49pvn24m1clvqdv35v65nfxk";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace build.sh --replace "sudo" ""

    # Don't generate windows cursors,
    # they aren't used and aren't installed
    # by the project's install script anyway.
    echo "exit 0" > w32-make.sh
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
    for x in Bibata_*; do
      cp -pr $x/out/X11/$x $out/share/icons/
    done
  '';

  meta = with stdenvNoCC.lib; {
    description = "Cursors Based on Bibata";
    homepage = https://github.com/KaizIqbal/Bibata_Extra_Cursor;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}
