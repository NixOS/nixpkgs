{ stdenv, lib, fetchurl, cmake, supercollider, fftw, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "sc3-plugins";
  version = "3.11.1";

  src = fetchurl {
    url = "https://github.com/supercollider/sc3-plugins/releases/download/Version-${version}/sc3-plugins-${version}-Source.tar.bz2";
    sha256 = "sha256-JjUmu7PJ+x3yRibr+Av2gTREng51fPo7Rk+B4y2JvkQ=";
  };

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

  stripDebugList = [ "lib" "share" ];

  passthru.updateScript = gitUpdater {
    url = "https://github.com/supercollider/sc3-plugins.git";
    rev-prefix = "Version-";
    ignoredVersions = "rc|beta";
  };

  meta = with lib; {
    description = "Community plugins for SuperCollider";
    homepage = "https://supercollider.github.io/sc3-plugins/";
    maintainers = with maintainers; [ lilyinstarlight ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
