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
, cacert
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "proj";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    hash = "sha256-cUnnJ9gOh65xBbfamfDkN7ajRdRLO5nUXRLeaBBMchg=";
  };

  patches = [
    # https://github.com/OSGeo/PROJ/pull/3252
    ./only-add-curl-for-static-builds.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ sqlite libtiff curl nlohmann_json ];

  nativeCheckInputs = [ cacert gtest ];

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
    changelog = "https://github.com/OSGeo/PROJ/blob/${src.rev}/NEWS";
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = licenses.mit;
    maintainers = with maintainers; teams.geospatial.members ++ [ dotlambda ];
    platforms = platforms.unix;
  };
})
