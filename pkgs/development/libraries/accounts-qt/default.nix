{ stdenv, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkgconfig, qtbase, qmake }:

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
  nativeBuildInputs = [ doxygen pkgconfig qmake ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = "http://code.google.com/p/accounts-sso/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nckx ];
    platforms = with platforms; linux;
  };
}
