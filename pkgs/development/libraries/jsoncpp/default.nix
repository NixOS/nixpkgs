{ stdenv , fetchFromGitHub , cmake , python }:

stdenv.mkDerivation rec {
  pname = "jsoncpp";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "1z0gj7a6jypkijmpknis04qybs1hkd04d1arr3gy89lnxmp6qzlm";
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
  preBuild = if stdenv.isDarwin then ''
    export DYLD_LIBRARY_PATH="`pwd`/src/lib_json:$DYLD_LIBRARY_PATH"
  '' else ''
    export LD_LIBRARY_PATH="`pwd`/src/lib_json:$LD_LIBRARY_PATH"
  '';

  nativeBuildInputs = [ cmake python ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
  ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A C++ library for interacting with JSON.";
    maintainers = with maintainers; [ ttuegel cpages nand0p ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
