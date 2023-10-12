{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, gtest
, valgrind
}:

stdenv.mkDerivation rec {
  pname = "rapidjson";
  version = "unstable-2023-09-28";

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "f9d53419e912910fd8fa57d5705fa41425428c35";
    hash = "sha256-rl7iy14jn1K2I5U2DrcZnoTQVEGEDKlxmdaOCF/3hfY=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  patches = [
    (fetchpatch {
      name = "do-not-include-gtest-src-dir.patch";
      url = "https://git.alpinelinux.org/aports/plain/community/rapidjson/do-not-include-gtest-src-dir.patch?id=9e5eefc7a5fcf5938a8dc8a3be8c75e9e6809909";
      hash = "sha256-BjSZEwfCXA/9V+kxQ/2JPWbc26jQn35CfN8+8NW24s4=";
    })
  ];

  # for tests, adding gtest to checkInputs does not work
  # https://github.com/NixOS/nixpkgs/pull/212200
  buildInputs = [ gtest ];
  cmakeFlags = [ "-DGTEST_SOURCE_DIR=${gtest.dev}/include" ];

  nativeCheckInputs = [ valgrind ];
  doCheck = !stdenv.hostPlatform.isStatic && !stdenv.isDarwin;

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Madouura ];
  };
}
