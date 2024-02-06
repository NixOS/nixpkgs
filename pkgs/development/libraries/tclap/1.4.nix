{ lib
, stdenv
, fetchgit
, cmake
, doxygen
, python3
}:
stdenv.mkDerivation {
  pname = "tclap";

  # This version is slightly newer than 1.4.0-rc1:
  # See https://github.com/mirror/tclap/compare/1.4.0-rc1..3feeb7b2499b37d9cb80890cadaf7c905a9a50c6
  version = "1.4-3feeb7b";

  src = fetchgit {
    url = "git://git.code.sf.net/p/tclap/code";
    rev = "3feeb7b2499b37d9cb80890cadaf7c905a9a50c6"; # 1.4 branch
    hash = "sha256-byLianB6Vf+I9ABMmsmuoGU2o5RO9c5sMckWW0F+GDM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR}
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    python3
  ];

  # Installing docs is broken in this package+version so we stub out some files
  preInstall = ''
    touch docs/manual.html
  '';

  doCheck = true;

  meta = with lib; {
    description = "Templatized C++ Command Line Parser Library (v1.4)";
    homepage = "https://tclap.sourceforge.net/";
    license = licenses.mit;
    maintainers = teams.deshaw.members;
    platforms = platforms.all;
  };
}
