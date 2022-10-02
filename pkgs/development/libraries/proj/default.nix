{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, buildPackages
, sqlite
, libtiff
, curl
, gtest
, nlohmann_json
}:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "sha256-zMP+WzC65BFz8g8mF5t7toqxmxCJePysd6WJuqpe8yg=";
  };

  # https://github.com/OSGeo/PROJ/issues/3206
  postPatch = ''
    # NB will not apply once https://github.com/OSGeo/PROJ/pull/3150 is released
    substituteInPlace cmake/ProjUtilities.cmake \
      --replace '$\{exec_prefix\}/$'{PROJ_LIB_SUBDIR} '$'{CMAKE_INSTALL_FULL_LIBDIR} \
      --replace '$\{prefix\}/$'{PROJ_INCLUDE_SUBDIR} '$'{CMAKE_INSTALL_FULL_INCLUDEDIR} \
      --replace '$\{prefix\}/$'{CMAKE_INSTALL_DATAROOTDIR} '$'{CMAKE_INSTALL_FULL_DATAROOTDIR}
    substituteInPlace cmake/project-config.cmake.in \
      --replace '$'{_ROOT}/@INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@ \
      --replace '$'{_ROOT}/@LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{_ROOT}/@BINDIR@ @CMAKE_INSTALL_FULL_BINDIR@
  '';

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

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
