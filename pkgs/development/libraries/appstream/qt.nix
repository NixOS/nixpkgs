{ mkDerivation, appstream, qtbase, qttools, nixosTests }:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

mkDerivation {
  pname = "appstream-qt";
  inherit (appstream) version src;

  outputs = [ "out" "dev" "installedTests" ];

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [ "-Dqt=true" ];

  patches = appstream.patches;

  postFixup = ''
    sed -i "$dev/lib/cmake/AppStreamQt/AppStreamQtConfig.cmake" \
      -e "/INTERFACE_INCLUDE_DIRECTORIES/ s@\''${PACKAGE_PREFIX_DIR}@$dev@"
  '';

  passthru = appstream.passthru // {
    tests = {
      installed-tests = nixosTests.installed-tests.appstream-qt;
    };
  };

  meta = appstream.meta // {
    description = "Software metadata handling library - Qt";
 };
}
