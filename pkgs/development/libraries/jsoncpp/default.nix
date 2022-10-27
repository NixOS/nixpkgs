{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, validatePkgConfig
, fetchpatch
, secureMemory ? false
, enableStatic ? stdenv.hostPlatform.isStatic
}:

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

  patches = [
    # Fix for https://github.com/open-source-parsers/jsoncpp/issues/1235.
    (fetchpatch {
      url = "https://github.com/open-source-parsers/jsoncpp/commit/ac2870298ed5b5a96a688d9df07461b31f83e906.patch";
      sha256 = "02wswhiwypmf1jn3rj9q1fw164kljiv4l8h0q6wyijzr77hq4wsg";
    })
  ];

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
  ]
    # the test's won't compile if secureMemory is used because there is no
    # comparison operators and conversion functions between
    # std::basic_string<..., Json::SecureAllocator<char>> vs.
    # std::basic_string<..., [default allocator]>
    ++ lib.optional ((stdenv.buildPlatform != stdenv.hostPlatform) || secureMemory) "-DJSONCPP_WITH_TESTS=OFF"
    ++ lib.optional (!enableStatic) "-DBUILD_STATIC_LIBS=OFF";

  # this is fixed and no longer necessary in 1.9.5 but there they use
  # memset_s without switching to a different c++ standard in the cmake files
  postInstall = lib.optionalString enableStatic ''
    (cd $out/lib && ln -sf libjsoncpp_static.a libjsoncpp.a)
  '';

  meta = with lib; {
    homepage = "https://github.com/open-source-parsers/jsoncpp";
    description = "A C++ library for interacting with JSON";
    maintainers = with maintainers; [ ttuegel cpages ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
