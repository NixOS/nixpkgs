{
  lib,
  qtModule,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  assimp,
}:

qtModule {
  pname = "qt3d";

  # make absolutely sure the vendored assimp is not used
  # patch cmake to accept assimp 6.x versions
  postPatch = ''
    rm -rf src/3rdparty/assimp/src
    substituteInPlace src/core/configure.cmake --replace-fail "WrapQt3DAssimp 5" "WrapQt3DAssimp 6"
  '';

  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtmultimedia
    assimp
  ];

  cmakeFlags = [
    (lib.cmakeBool "FEATURE_qt3d_system_assimp" true) # use nix assimp
    (lib.cmakeBool "TEST_assimp" true) # required for internal cmake asserts
  ];
}
