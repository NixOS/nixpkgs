{ stdenv
, fetchFromGitHub
, cmake
, python
}:
stdenv.mkDerivation rec {
  name = "jsoncpp-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "1lg22zrjnl10x1bw0wfz72xd2kfbzynyggk8vdwd89mp1g8xjl9d";
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
  ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = https://github.com/open-source-parsers/jsoncpp;
    description = "A C++ library for interacting with JSON.";
    maintainers = with maintainers; [ ttuegel cpages ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
