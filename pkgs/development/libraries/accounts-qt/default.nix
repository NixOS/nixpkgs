{ stdenv, fetchurl, doxygen, glib, libaccounts-glib, pkgconfig, qt5 }:

stdenv.mkDerivation rec {
  name = "accounts-qt-1.11";
  src = fetchurl {
    url = "https://accounts-sso.googlecode.com/files/${name}.tar.bz2";
    sha256 = "07drh4s7zaz4bzg2xhwm50ig1g8vlphfv02nrzz1yi085az1fmch";
  };

  buildInputs = [ glib libaccounts-glib qt5.base ];
  nativeBuildInputs = [ doxygen pkgconfig ];

  configurePhase = ''
    qmake PREFIX=$out LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake/AccountsQt5
  '';

  postInstall = ''
    mv $out/lib/cmake/AccountsQt5/AccountsQtConfig.cmake \
       $out/lib/cmake/AccountsQt5/AccountsQt5Config.cmake
    mv $out/lib/cmake/AccountsQt5/AccountsQtConfigVersion.cmake \
       $out/lib/cmake/AccountsQt5/AccountsQt5ConfigVersion.cmake
  '';
}
