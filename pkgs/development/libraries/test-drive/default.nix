{ stdenv, lib, fetchFromGitHub, gfortran, cmake }:

stdenv.mkDerivation rec {
  pname = "test-drive";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ObAnHFP1Hp0knf/jtGHynVF0CCqK47eqetePx4NLmlM=";
  };

  postPatch = ''
    substituteInPlace config/template.pc \
      --replace 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' "libdir=@CMAKE_INSTALL_LIBDIR@" \
      --replace 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' "includedir=@CMAKE_INSTALL_INCLUDEDIR@"
  '';

  nativeBuildInputs = [
    gfortran
    cmake
  ];

  meta = with lib; {
    description = "Procedural Fortran testing framework";
    homepage = "https://github.com/fortran-lang/test-drive";
    license = with licenses; [ asl20 mit ] ;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
