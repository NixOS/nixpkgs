{ stdenv, fetchFromGitHub, gtk3, gnome-themes-extra, gtk-engine-murrine, bc }:
stdenv.mkDerivation rec {
  pname = "orchis-theme";
<<<<<<< HEAD
<<<<<<< HEAD
  version = "unstable-2020-10-25";
=======
  version = "unstable";
>>>>>>> d6e57063ca5 (orchis-theme: latest commit packaged by @ImExtends)
=======
  version = "unstable-2020-10-25";
>>>>>>> 776f1ce64ef (Fixed missing date.)

  src = fetchFromGitHub {
    repo = "Orchis-theme";
    owner = "vinceliuice";
    rev = "6369f17e4b98599bb8113b52e4ed6ca7bd20103e";
    sha256 = "1l3icm7z8rq962bp47kklgivi2hlxnmv99q06h0qz7nsp0jaimzi";
  };

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 6eef0e5e706 (orchis-theme: gtk3 moved to nativeBuildInputs.)
  nativeBuildInputs = [ gtk3 bc ];

  buildInputs = [ gnome-themes-extra ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];
<<<<<<< HEAD
=======
  buildInputs = [ gtk3 gnome-themes-extra gtk-engine-murrine bc ];
>>>>>>> d6e57063ca5 (orchis-theme: latest commit packaged by @ImExtends)
=======
>>>>>>> 6eef0e5e706 (orchis-theme: gtk3 moved to nativeBuildInputs.)

  patchPhase = ''patchShebangs install.sh'';

  installPhase = ''
    mkdir -p $out/share/themes
    ./install.sh --dest $out/share/themes
  '';
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
    
>>>>>>> d157e6abf9e (Added meta.)
=======

>>>>>>> 6eef0e5e706 (orchis-theme: gtk3 moved to nativeBuildInputs.)
  meta = with stdenv.lib; {
    description = "Orchis is a theme for GNOME/GTK based desktop environments";
    homepage = "https://github.com/vinceliuice/Orchis-theme";
    license = licenses.gpl3;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ icy-ihought ];
  };

=======
>>>>>>> d6e57063ca5 (orchis-theme: latest commit packaged by @ImExtends)
=======
    maintainers = with maintainers; [ Icy-Thought ];
  };
<<<<<<< HEAD
>>>>>>> d157e6abf9e (Added meta.)
=======

>>>>>>> 6eef0e5e706 (orchis-theme: gtk3 moved to nativeBuildInputs.)
}
