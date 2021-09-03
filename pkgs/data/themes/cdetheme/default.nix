{ lib, stdenv, fetchFromGitHub, python2Packages }:

stdenv.mkDerivation rec {
  pname = "cdetheme";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "josvanr";
    repo = "cde-motif-theme";
    rev = version;
    sha256 = "1v5c4db69cmzdci8xxlkx3s3cifg1h5160qq5siwfps0sj7pvggj";
  };

  dontBuild = true;

  pythonPath = with python2Packages; [ pyqt4 pillow pyxdg pyyaml ];
  nativeBuildInputs = with python2Packages; [ python wrapPython ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r cdetheme $out/share/themes
    patchShebangs $out/share/themes/cdetheme/scripts/switchtheme
    wrapPythonProgramsIn "$out/share/themes/cdetheme/scripts" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Gtk2 / Gtk3 theme mimicking CDE / Motif";
    homepage = "https://www.gnome-look.org/p/1231025";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ ];
    hydraPlatforms = [];
  };
}
