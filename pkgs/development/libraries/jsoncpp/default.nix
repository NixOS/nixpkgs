{ stdenv, fetchFromGitHub, cmake, python, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "jsoncpp";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "037d1b1qdmn3rksmn1j71j26bv4hkjv7sn7da261k853xb5899sg";
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

  # fix inverted sense in isAnyCharRequiredQuoting on aarch64. See: https://github.com/open-source-parsers/jsoncpp/pull/1120
  patches = stdenv.lib.optionals stdenv.isAarch64 [
    (fetchpatch {
      url = "https://github.com/open-source-parsers/jsoncpp/commit/9093358efae9e5981aa60013487fc7215f040a59.patch";
      sha256 = "1wiqp70sck2md14sfc0zdkblqk9750cl55ykf9d6b9vs1ifzzzq5";
     })
  ];

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
