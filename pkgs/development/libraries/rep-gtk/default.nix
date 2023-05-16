{ lib
, stdenv
, fetchurl
, autoreconfHook
<<<<<<< HEAD
, gtk2-x11
=======
, gtk2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, librep
, pkg-config
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "rep-gtk";
  version = "0.90.8.3";

  src = fetchurl {
<<<<<<< HEAD
    url = "https://download.tuxfamily.org/librep/rep-gtk/rep-gtk_${finalAttrs.version}.tar.xz";
    hash = "sha256-qWV120V5Tu/QVkFylno47y1/7DriZExHjp99VLmf80E=";
=======
    url = "https://download.tuxfamily.org/librep/${pname}/${pname}_${version}.tar.xz";
    sha256 = "0hgkkywm8zczir3lqr727bn7ybgg71x9cwj1av8fykkr8pdpard9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
<<<<<<< HEAD
    librep
  ];

  buildInputs = [
    gtk2-x11
    librep
  ];

  strictDeps = true;

=======
  ];
  buildInputs = [
    gtk2
    librep
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  patchPhase = ''
    sed -e 's|installdir=$(repexecdir)|installdir=$(libdir)/rep|g' -i Makefile.in
  '';

<<<<<<< HEAD
  meta = {
    homepage = "http://sawfish.tuxfamily.org";
    description = "GTK bindings for librep";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    homepage = "http://sawfish.tuxfamily.org";
    description = "GTK bindings for librep";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# TODO: investigate fetchFromGithub
