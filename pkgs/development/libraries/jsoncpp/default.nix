{ stdenv, fetchFromGitHub, cmake, python, validatePkgConfig, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "jsoncpp";
  version = "1.9.4";

  outputs = ["out" "dev"];

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "0qnx5y6c90fphl9mj9d20j2dfgy6s5yr5l0xnzid0vh71zrp6jwv";
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
    export DYLD_LIBRARY_PATH="$PWD/lib''${DYLD_LIBRARY_PATH:+:}$DYLD_LIBRARY_PATH"
  '' else ''
    export LD_LIBRARY_PATH="$PWD/lib''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  nativeBuildInputs = [ cmake python validatePkgConfig ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    "-DBUILD_OBJECT_LIBS=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
  ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "A C++ library for interacting with JSON";
    maintainers = with maintainers; [ ttuegel cpages nand0p ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
