{ stdenv, appstream, qtbase, qttools }:

# TODO: look into using the libraries from the regular appstream derivation as we keep duplicates here

stdenv.mkDerivation rec {
  name = "appstream-qt-${version}";
  inherit (appstream) version src prePatch;

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [ "-Dqt=true" ];

  meta = appstream.meta // {
    description = "Software metadata handling library - Qt";
 };
}
