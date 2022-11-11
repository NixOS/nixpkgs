{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, gtest
}:

stdenv.mkDerivation rec {
  pname = "rapidjson";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "miloyip";
    repo = "rapidjson";
    rev = "v${version}";
    sha256 = "1jixgb8w97l9gdh3inihz7avz7i770gy2j2irvvlyrq3wi41f5ab";
  };

  patches = [
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/rapidjson/raw/48402da9f19d060ffcd40bf2b2e6987212c58b0c/f/rapidjson-1.1.0-c++20.patch";
      sha256 = "1qm62iad1xfsixv1li7qy475xc7gc04hmi2q21qdk6l69gk7mf82";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/rapidjson/do-not-include-gtest-src-dir.patch";
      hash = "sha256-BjSZEwfCXA/9V+kxQ/2JPWbc26jQn35CfN8+8NW24s4=";
    })
  ];

  postPatch = ''
    find -name CMakeLists.txt | xargs \
      sed -i -e "s/-Werror//g" -e "s/-march=native//g"
  '';

  nativeBuildInputs = [ pkg-config cmake ];

  cmakeFlags = [
    "-DGTEST_SOURCE_DIR=${gtest.dev}/include"
  ] ++ lib.optionals (!doCheck) [
    "-DRAPIDJSON_BUILD_TESTS=OFF"
  ];

  checkInputs = [
    gtest
  ];

  checkPhase = ''
    runHook preCheck

    ctest -E '.*valgrind.*'

    runHook postCheck
  '';

  doCheck = !stdenv.hostPlatform.isStatic;

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan dotlambda ];
  };
}
