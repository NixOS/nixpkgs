{ stdenv, requireFile, p7zip, cmake, mesa, libX11, libXi, ... }:

let 
  sourceInfo = rec {
    baseName="box2d";
    version="2.3.0";
    name="${baseName}-${version}";
    url="http://box2d.googlecode.com/files/Box2D_v${version}.7z";
    hash="2ebdb30863b7f5478e99b4425af210f8c32ef62faf1e0d2414c653072fff403d";
  };
in
stdenv.mkDerivation rec {
  src = requireFile {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
    name = "Box2D_v${version}.7z";
  };

  inherit (sourceInfo) name version;
  buildInputs = [ p7zip cmake mesa libX11 libXi ];

  unpackPhase = ''
    7z x ${src}
    cd Box2D_v${version}
  '';

  preConfigurePhase = ''
    sed -i Box2D/Common/b2Settings.h -e 's@b2_maxPolygonVertices .*@b2_maxPolygonVertices 15@'
  '';
      
  configurePhase = ''
    cd Box2D/Build; 
    cmake -DBOX2D_INSTALL=ON -DBOX2D_BUILD_SHARED=ON -DCMAKE_INSTALL_PREFIX=$out ..
  '';

  meta = {
    description = "2D physics engine";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin 
      qknight
    ];
    platforms = with stdenv.lib.platforms;
      linux;
    license = "bsd";
    #homepage = http://code.google.com/p/box2d/downloads/list;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/box2d/downloads/list";
    };
  };

}

