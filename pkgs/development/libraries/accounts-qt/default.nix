{ stdenv, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkgconfig, qtbase, qmake, graphviz }:

stdenv.mkDerivation rec {
  pname = "accounts-qt";
  version = "1.16";

  src = fetchFromGitLab {
    sha256 = "1vmpjvysm0ld8dqnx8msa15hlhrkny02cqycsh4k2azrnijg0xjz";
    rev = "VERSION_${version}";
    repo = "libaccounts-qt";
    owner = "accounts-sso";
  };

  buildInputs = [ glib libaccounts-glib qtbase ];
  nativeBuildInputs = [ doxygen pkgconfig qmake graphviz ];

# Commented due to error 'accounts-qt5 development package not found' when tried to build oauth2 plugin for signon
# It seems like this options do something wrong
#  preConfigure = ''
#    qmakeFlags="$qmakeFlags LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake"
#  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = "https://gitlab.com/accounts-sso";
    license = licenses.lgpl21;
    platforms = with platforms; linux;
  };
}
