{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "jsoncpp-${version}";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "08y54n4v3q18ik8iv8zyziava3x130ilzf1l3qli3vjwf6l42fm0";
  };

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
  preBuild = ''
    export LD_LIBRARY_PATH="`pwd`/src/lib_json:$LD_LIBRARY_PATH"
  '';

  nativeBuildInputs = [ cmake python ];

  CXXFLAGS = "-Wno-shift-negative-value";

  cmakeFlags = [
    "-DJSONCPP_LIB_BUILD_SHARED=ON"
    "-DJSONCPP_LIB_BUILD_STATIC=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
  ];

  meta = {
    inherit version;
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A simple API to manipulate JSON data in C++";
    maintainers = with stdenv.lib.maintainers; [ ttuegel page ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
    branch = "1.6";
  };
}
