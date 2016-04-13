{ stdenv, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkgconfig, qtbase }:

stdenv.mkDerivation rec {
  name = "accounts-qt-${version}";
  version = "1.13";

  src = fetchFromGitLab {
    sha256 = "1gpkgw05dwsf2wk5cy3skgss3kw6mqh7iv3fadrxqxfc1za1xmyl";
    rev = version;
    repo = "libaccounts-qt";
    owner = "accounts-sso";
  };

  buildInputs = [ glib libaccounts-glib qtbase ];
  nativeBuildInputs = [ doxygen pkgconfig ];

  configurePhase = ''
    qmake PREFIX=$out LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake
  '';

  meta = with stdenv.lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = "http://code.google.com/p/accounts-sso/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nckx ];
  };
}
