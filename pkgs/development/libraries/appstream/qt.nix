{ mkDerivation, appstream, qtbase, qttools }:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

mkDerivation {
  pname = "appstream-qt";
  inherit (appstream) version src patches;

  outputs = [ "out" "dev" ];

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [ "-Dqt=true" ];

  postFixup = ''
    sed -i "$dev/lib/cmake/AppStreamQt/AppStreamQtConfig.cmake" \
      -e "/INTERFACE_INCLUDE_DIRECTORIES/ s@\''${PACKAGE_PREFIX_DIR}@$dev@"
  '';

  meta = appstream.meta // {
    description = "Software metadata handling library - Qt";
 };
}
