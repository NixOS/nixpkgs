{ stdenv, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkgconfig, qt5 }:

let version = "1.13"; in
stdenv.mkDerivation rec {
  name = "accounts-qt-${version}";

  src = fetchFromGitLab {
    sha256 = "1gpkgw05dwsf2wk5cy3skgss3kw6mqh7iv3fadrxqxfc1za1xmyl";
    rev = version;
    repo = "libaccounts-qt";
    owner = "accounts-sso";
  };

  meta = with stdenv.lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = "http://code.google.com/p/accounts-sso/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ glib libaccounts-glib qt5.base ];
  nativeBuildInputs = [ doxygen pkgconfig ];

  configurePhase = ''
    qmake PREFIX=$out LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake
  '';
}
