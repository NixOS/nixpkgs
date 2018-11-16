{ stdenv, requireFile, cmake, libGLU_combined, libX11, libXi }:

let 
  sourceInfo = rec {
    version="1.1.0";
    name="liquidfun-${version}";
    url="https://github.com/google/liquidfun/releases/download/v${version}/${name}";
    hash="5011a000eacd6202a47317c489e44aa753a833fb562d970e7b8c0da9de01df86";
  };
in
stdenv.mkDerivation rec {
  src = requireFile {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    name = sourceInfo.name + ".tar.gz";
  };

  inherit (sourceInfo) name version;
  buildInputs = [ cmake libGLU_combined libX11 libXi ];

  sourceRoot = "liquidfun/Box2D/";

  preConfigurePhases = "preConfigure";

  preConfigure = ''
    sed -i Box2D/Common/b2Settings.h -e 's@b2_maxPolygonVertices .*@b2_maxPolygonVertices 15@'
    substituteInPlace Box2D/CMakeLists.txt --replace "Common/b2GrowableStack.h" "Common/b2GrowableStack.h Common/b2GrowableBuffer.h"
  '';
      
  configurePhase = ''
    mkdir Build
    cd Build; 
    cmake -DBOX2D_INSTALL=ON -DBOX2D_BUILD_SHARED=ON -DCMAKE_INSTALL_PREFIX=$out ..
  '';

  meta = {
    description = "2D physics engine based on Box2D";
    maintainers = with stdenv.lib.maintainers;
    [
      qknight
    ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
    license = stdenv.lib.licenses.bsd2;
    homepage = https://google.github.io/liquidfun/;
  };
}

