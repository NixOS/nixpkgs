{ stdenv, fetchFromGitHub, python2, xvfb_run
, palette ? "Broica"
, numOfColors ? 8 }:

assert numOfColors == 4 || numOfColors == 8;

stdenv.mkDerivation rec {
  pname = "cdetheme";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "josvanr";
    repo = "cde-motif-theme";
    rev = version;
    sha256 = "1v5c4db69cmzdci8xxlkx3s3cifg1h5160qq5siwfps0sj7pvggj";
  };

  dontInstall = true;

  buildInputs = [
    (python2.withPackages (pythonPackages: with pythonPackages; [
      pyqt4 pillow pyxdg pyyaml
    ]))
    xvfb_run
  ];

  buildPhase = ''
    export HOME=$(pwd)
    cd cdetheme/scripts
    substituteInPlace switchtheme \
      --replace "Globals.themesrcdir=Globals.themedir" "Globals.themesrcdir='$HOME/cdetheme'" \
      --replace "Globals.themedir=os.path.join(userhome,'.themes','cdetheme')" "Globals.themedir='$out/share/themes/cdetheme'" \
      --replace "opts.ncolors=8" ""
    xvfb-run python ./switchtheme ../palettes/${palette}.dp ${builtins.toString numOfColors} 0 0 false true false
  '';

  meta = with stdenv.lib; {
    description = "Gtk2 / Gtk3 theme mimicking CDE / Motif";
    homepage = "https://www.gnome-look.org/p/1231025";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ gnidorah ];
    hydraPlatforms = [];
  };
}
