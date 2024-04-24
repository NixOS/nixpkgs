{ lib, stdenv, appstream, qtbase, qttools, nixosTests }:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

let
  qtSuffix = lib.optionalString (lib.versions.major qtbase.version == "5") "5";
in
stdenv.mkDerivation {
  pname = "appstream-qt";
  inherit (appstream) version src;

  outputs = [ "out" "dev" "installedTests" ];

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [
    (lib.mesonBool "qt" true)
    (lib.mesonOption "qt-versions" (lib.versions.major qtbase.version))
  ];

  patches = appstream.patches;

  dontWrapQtApps = true;

  postFixup = ''
    sed -i "$dev/lib/cmake/AppStreamQt${qtSuffix}/AppStreamQt${qtSuffix}Config.cmake" \
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
