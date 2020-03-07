{ stdenv, fetchFromGitLab, doxygen, glib, libaccounts-glib, pkgconfig, qtbase, qmake }:

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
  nativeBuildInputs = [ doxygen pkgconfig qmake ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Qt library for accessing the online accounts database";
    homepage = https://gitlab.com/accounts-sso;
    license = licenses.lgpl21;
    platforms = with platforms; linux;
  };
}
