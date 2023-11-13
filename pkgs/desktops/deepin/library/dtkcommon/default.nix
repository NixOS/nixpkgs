{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, cmake
, qtbase
, qttools
, wrapQtAppsHook
, glib
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.6.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-FHXwgFTevCGTNUPlb/oeltE2//Sjwz7YVvko7QPOsRo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [ qtbase ];

  qmakeFlags = [ "PREFIX=${placeholder "out"}" ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  meta = with lib; {
    description = "A public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
