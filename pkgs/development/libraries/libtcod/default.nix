{ lib, stdenv, fetchFromBitbucket, cmake, SDL, libGLU, libGL, upx, zlib }:

stdenv.mkDerivation {

  pname = "libtcod";
  version = "1.5.1";

  src = fetchFromBitbucket {
    owner = "libtcod";
    repo = "libtcod";
    rev = "1.5.1";
    hash = "sha256-w9BlI6xFR1fY/85/L7p+UIxmVyyMTjz7tSKcGm21esU=";
  };

  prePatch = ''
    sed -i CMakeLists.txt \
      -e "s,SET(ROOT_DIR.*,SET(ROOT_DIR $out),g" \
      -e "s,SET(INSTALL_DIR.*,SET(INSTALL_DIR $out),g"
    echo 'INSTALL(DIRECTORY include DESTINATION .)' >> CMakeLists.txt
  '';

  cmakeFlags = [ "-DLIBTCOD_SAMPLES=OFF" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ SDL libGLU libGL upx zlib ];

  meta = {
    description = "API for roguelike games";
    homepage = "http://roguecentral.org/doryen/libtcod/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
