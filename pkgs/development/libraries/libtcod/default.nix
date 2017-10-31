{ stdenv, fetchFromBitbucket, cmake, SDL, mesa, upx, zlib }:

stdenv.mkDerivation rec {

  name = "libtcod-${version}";
  version = "1.5.1";

  src = fetchFromBitbucket {
    owner = "libtcod";
    repo = "libtcod";
    rev = "1.5.1";
    sha256 = "1ibsnmnim712npxkqklc5ibnd32hgsx2yzyfzzc5fis5mhinbl63";
  };

  prePatch = ''
    sed -i CMakeLists.txt \
      -e "s,SET(ROOT_DIR.*,SET(ROOT_DIR $out),g" \
      -e "s,SET(INSTALL_DIR.*,SET(INSTALL_DIR $out),g"
    echo 'INSTALL(DIRECTORY include DESTINATION .)' >> CMakeLists.txt
  '';

  cmakeFlags="-DLIBTCOD_SAMPLES=OFF";

  buildInputs = [ cmake SDL mesa upx zlib ];

  meta = {
    description = "API for roguelike games";
    homepage = http://roguecentral.org/doryen/libtcod/;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.skeidel ];
  };
}
