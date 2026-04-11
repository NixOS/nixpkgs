{
  stdenv,
  lib,
  fetchpatch2,
  fetchurl,
  cmake,
  supercollider,
  fftw,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "sc3-plugins";
  version = "3.13.0";

  src = fetchurl {
    url = "https://github.com/supercollider/sc3-plugins/releases/download/Version-${version}/sc3-plugins-${version}-Source.tar.bz2";
    sha256 = "sha256-+N7rhh1ALipy21HUC0jEQ2kCYbWlOveJg9TPe6dnF6I=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/supercollider/sc3-plugins/commit/3dc56bf7fcc1f2261afc13f96da762b78bcbfa51.patch";
      hash = "sha256-lvXvGunfmjt6i+XPog14IKdnH1Qk8vefxplSDkXXXHU=";
    })

    # Fix build with GCC 15
    (fetchpatch2 {
      url = "https://github.com/supercollider/sc3-plugins/commit/deaa55a7204bedf65a2000a463ae87a481bf3eb8.patch";
      hash = "sha256-d8+4ZmedAwVt/AlU/YKqQF+80shEa8DiPnvMwJtW/RM=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    supercollider
    fftw
  ];

  cmakeFlags = [
    "-DSC_PATH=${supercollider}/include/SuperCollider"
    "-DSUPERNOVA=ON"
  ];

  stripDebugList = [
    "lib"
    "share"
  ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/supercollider/sc3-plugins.git";
    rev-prefix = "Version-";
    ignoredVersions = "rc|beta";
  };

  meta = {
    description = "Community plugins for SuperCollider";
    homepage = "https://supercollider.github.io/sc3-plugins/";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
