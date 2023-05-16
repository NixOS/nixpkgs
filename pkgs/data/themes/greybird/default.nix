{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, sassc
, gdk-pixbuf
, librsvg
, gtk-engine-murrine
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "greybird";
<<<<<<< HEAD
  version = "3.23.3";
=======
  version = "3.23.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "shimmerproject";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "+MZQ3FThuRFEfoARsF09B7POwytS5RgTs9zYzIHVtfg=";
=======
    sha256 = "h4sPjKpTufaunVP0d4Z5x/K+vRW1FpuLrMJjydx/a6w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = with lib; {
    description = "Grey and blue theme from the Shimmer Project for GTK-based environments";
    homepage = "https://github.com/shimmerproject/Greybird";
    license = [ licenses.gpl2Plus ]; # or alternatively: cc-by-nc-sa-30 or later
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
