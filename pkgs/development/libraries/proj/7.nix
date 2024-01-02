{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, sqlite
, libtiff
, curl
, gtest
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "0mymvfvs8xggl4axvlj7kc1ksd9g94kaz6w1vdv0x2y5mqk93gx9";
  };

  patches = [
    (fetchpatch { # https://github.com/OSGeo/PROJ/issues/2557
      name = "gie_self_tests-fail.diff"; # included in >= 8.0.1
      url = "https://github.com/OSGeo/PROJ/commit/6f1a3c4648bf06862dca0b3725cbb3b7ee0284e3.diff";
      sha256 = "0gapny0a9c3r0x9szjgn86sspjrrf4vwbija77b17w6ci5cq4pdf";
    })
    ./tests-sqlite-3.39.patch
  ];

  postPatch = lib.optionalString (version == "7.2.1") ''
    substituteInPlace CMakeLists.txt \
      --replace "MAJOR 7 MINOR 2 PATCH 0" "MAJOR 7 MINOR 2 PATCH 1"
  '';

  outputs = [ "out" "dev"];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ sqlite libtiff curl ];

  nativeCheckInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_GTEST=ON"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj4.org";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
