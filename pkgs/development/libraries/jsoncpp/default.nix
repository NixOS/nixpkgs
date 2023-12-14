{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, validatePkgConfig
, secureMemory ? false
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation rec {
  pname = "jsoncpp";
  version = "1.9.5";

  outputs = ["out" "dev"];

  src = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = version;
    sha256 = "sha256-OyfJD19g8cT9wOD0hyJyEw4TbaxZ9eY04396U/7R+hs=";
  };

  /* During darwin bootstrap, we have a cp that doesn't understand the
   * --reflink=auto flag, which is used in the default unpackPhase for dirs
   */
  unpackPhase = ''
    cp -a ${src} ${src.name}
    chmod -R +w ${src.name}
    export sourceRoot=${src.name}
  '';

  postPatch = lib.optionalString secureMemory ''
    sed -i 's/#define JSONCPP_USING_SECURE_MEMORY 0/#define JSONCPP_USING_SECURE_MEMORY 1/' include/json/version.h
  '';

  nativeBuildInputs = [ cmake python3 validatePkgConfig ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_OBJECT_LIBS=OFF"
    "-DJSONCPP_WITH_CMAKE_PACKAGE=ON"
    "-DBUILD_STATIC_LIBS=${if enableStatic then "ON" else "OFF"}"
  ]
    # the test's won't compile if secureMemory is used because there is no
    # comparison operators and conversion functions between
    # std::basic_string<..., Json::SecureAllocator<char>> vs.
    # std::basic_string<..., [default allocator]>
    ++ lib.optional ((stdenv.buildPlatform != stdenv.hostPlatform) || secureMemory) "-DJSONCPP_WITH_TESTS=OFF";

  meta = with lib; {
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "A C++ library for interacting with JSON";
    maintainers = with maintainers; [ ttuegel cpages ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
