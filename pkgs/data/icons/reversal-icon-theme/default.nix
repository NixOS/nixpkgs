<<<<<<< HEAD
<<<<<<< HEAD
{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra }:
stdenv.mkDerivation rec {
  pname = "reversal-icon-theme";
  version = "unstable-2020-10-31";
=======
{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra, gtk-engine-murrine, bc }:
=======
{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra }:
>>>>>>> 67ab5177fbf (reversal-icon-theme: gtk3 moved, bc opt-ed out.)
stdenv.mkDerivation rec {
  pname = "reversal-icon-theme";
<<<<<<< HEAD
  version = "unstable";
>>>>>>> 81ee8dca964 (reversal-icon-theme: fb6cb29 packaged by @ImExtends)
=======
  version = "unstable-2020-10-31";
>>>>>>> 910e16a6f9e (Fixed wrong installation directory + date.)

  src = fetchFromGitHub {
    repo = "Reversal-icon-theme";
    owner = "yeyushengfan258";
    rev = "fb6cb29e02991915931cf1ed9b88d5257f177ed2";
    sha256 = "15vml083kd40hzfb6s1f5xndwqz6ys58sg076cvpz9vsbxhwbjnl";
  };

<<<<<<< HEAD
<<<<<<< HEAD
  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ gnome-themes-extra ];
=======
  buildInputs = [ gtk3 gnome-themes-extra gtk-engine-murrine bc ];
>>>>>>> 81ee8dca964 (reversal-icon-theme: fb6cb29 packaged by @ImExtends)
=======
  nativeBuildInputs = [ gtk3 ];

  buildInputs = [ gnome-themes-extra ];
>>>>>>> 67ab5177fbf (reversal-icon-theme: gtk3 moved, bc opt-ed out.)

  patchPhase = ''patchShebangs install.sh'';

  installPhase = ''
<<<<<<< HEAD
<<<<<<< HEAD
    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons
  '';

  meta = with stdenv.lib; {
    description = "Reversal icon theme";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ icy-thought ];
  };

=======
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes
=======
    mkdir -p $out/share/icons
    ./install.sh --dest $out/share/icons
>>>>>>> 910e16a6f9e (Fixed wrong installation directory + date.)
  '';
<<<<<<< HEAD
<<<<<<< HEAD

>>>>>>> 81ee8dca964 (reversal-icon-theme: fb6cb29 packaged by @ImExtends)
=======
  
=======

>>>>>>> 67ab5177fbf (reversal-icon-theme: gtk3 moved, bc opt-ed out.)
  meta = with stdenv.lib; {
    description = "Reversal icon theme";
    homepage = "https://github.com/yeyushengfan258/Reversal-icon-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Icy-Thought ];
  };
<<<<<<< HEAD
>>>>>>> 62ba3936025 (Added meta)
=======

>>>>>>> 67ab5177fbf (reversal-icon-theme: gtk3 moved, bc opt-ed out.)
}
