{ stdenv, appstream, qtbase, qttools }:

stdenv.mkDerivation rec {
  name = "appstream-qt-${version}";
  inherit (appstream) version src prePatch;

  buildInputs = appstream.buildInputs ++ [ appstream qtbase ];

  nativeBuildInputs = appstream.nativeBuildInputs ++ [ qttools ];

  mesonFlags = appstream.mesonFlags ++ [ "-Dqt=true" ];

  postInstall = ''
    rm -rf $out/{bin,etc,include/appstream,lib/pkgconfig,lib/libappstream.so*,share}
  '';

  preFixup = ''
    patchelf --add-needed ${appstream}/lib/libappstream.so.4 \
      $out/lib/libAppStreamQt.so
  '';

  meta = appstream.meta // {
    description = "Software metadata handling library - Qt";
 };
}
