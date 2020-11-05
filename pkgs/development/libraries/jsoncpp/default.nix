{ stdenv, lib, fetchFromGitHub, cmake, python3, validatePkgConfig, static ? false }:

stdenv.mkDerivation rec {
  pname = "jsoncpp";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "m0tz8w8HbtDitx3Qkn3Rxj/XhASiJVkThdeBxIwv3WI=";
  };

  outputs = if static then [ "out" ] else [ "out" "dev" ];

  /* During darwin bootstrap, we have a cp that doesn't understand the
   * --reflink=auto flag, which is used in the default unpackPhase for dirs
   */
  unpackPhase = ''
    cp -a ${src} ${src.name}
    chmod -R +w ${src.name}
    export sourceRoot=${src.name}
  '';

  # Hack to be able to run the test, broken because we use
  # CMAKE_SKIP_BUILD_RPATH to avoid cmake resetting rpath on install
  preBuild = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH="`pwd`/lib''${DYLD_LIBRARY_PATH:+:}$DYLD_LIBRARY_PATH"
  '' else ''
    export LD_LIBRARY_PATH="`pwd`/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  nativeBuildInputs = [ cmake python3 ] ++ lib.optional (!static) [ validatePkgConfig ];

  cmakeFlags = [
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
    "-DJSONCPP_WITH_PKGCONFIG_SUPPORT=ON"
    "-DBUILD_OBJECT_LIBS=OFF"
  ] ++ lib.optional static    "-DBUILD_SHARED_LIBS=OFF"
    ++ lib.optional (!static) "-DBUILD_STATIC_LIBS=OFF";

  meta = with lib; {
    inherit version;
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "A C++ library for interacting with JSON";
    maintainers = with maintainers; [ ttuegel cpages nand0p ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
