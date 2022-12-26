{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, buildPackages
, callPackage
, sqlite
, libtiff
, curl
, gtest
, nlohmann_json
, python3
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "proj";
  version = "9.1.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    hash = "sha256-yw7eSm64qFFt9egJWKVyVo0e7xQRSmfUY7pk6Cwvwdk=";
  };

  patches = [
    # https://github.com/OSGeo/PROJ/pull/3252
    (fetchpatch {
      name = "only-add-find_dependencyCURL-for-static-builds.patch";
      url = "https://github.com/OSGeo/PROJ/commit/11f4597bbb7069bd5d4391597808703bd96df849.patch";
      hash = "sha256-4w5Cu2m5VJZr6E2dUVRyWJdED2TyS8cI8G20EwfQ4u0=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ sqlite libtiff curl nlohmann_json ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_GTEST=ON"
    "-DRUN_NETWORK_DEPENDENT_TESTS=OFF"
    "-DNLOHMANN_JSON_ORIGIN=external"
    "-DEXE_SQLITE3=${buildPackages.sqlite}/bin/sqlite3"
  ];

  preCheck =
    let
      libPathEnvVar = if stdenv.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
    in
      ''
        export HOME=$TMPDIR
        export TMP=$TMPDIR
        export ${libPathEnvVar}=$PWD/lib
      '';

  doCheck = true;

  passthru.tests = {
    python = python3.pkgs.pyproj;
    proj = callPackage ./tests.nix { proj = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
})
