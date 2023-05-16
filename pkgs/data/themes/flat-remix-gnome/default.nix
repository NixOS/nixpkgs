{ stdenv
, fetchFromGitHub
, glib
, lib
, writeScriptBin
}:
let
  # make install will use dconf to find desktop background file uri.
  # consider adding an args to allow specify pictures manually.
<<<<<<< HEAD
  # https://github.com/daniruiz/flat-remix-gnome/blob/20230606/Makefile#L38
=======
  # https://github.com/daniruiz/flat-remix-gnome/blob/20221107/Makefile#L38
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  fake-dconf = writeScriptBin "dconf" "echo -n";
in
stdenv.mkDerivation rec {
  pname = "flat-remix-gnome";
<<<<<<< HEAD
  version = "20230606";
=======
  version = "20221107";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "daniruiz";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-NnCRWADyAOR5yyOjB18zSQov+5FfKhhCSkDXBAL80wo=";
=======
    hash = "sha256-5V3ECbQe3/5bhHnMR1pzvehs1eh0u9U7E1voDiqo9cY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ glib fake-dconf ];
  makeFlags = [ "PREFIX=$(out)" ];

  # make install will back up this file, it will fail if the file doesn't exist.
<<<<<<< HEAD
  # https://github.com/daniruiz/flat-remix-gnome/blob/20230606/Makefile#L56
=======
  # https://github.com/daniruiz/flat-remix-gnome/blob/20221107/Makefile#L56
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preInstall = ''
    mkdir -p $out/share/gnome-shell/
    touch $out/share/gnome-shell/gnome-shell-theme.gresource
  '';

  postInstall = ''
    rm $out/share/gnome-shell/gnome-shell-theme.gresource.old
  '';

  meta = with lib; {
    description = "GNOME Shell theme inspired by material design.";
    homepage = "https://drasite.com/flat-remix-gnome";
    license = licenses.cc-by-sa-40;
    platforms = platforms.linux;
    maintainers = [ maintainers.vanilla ];
  };
}
