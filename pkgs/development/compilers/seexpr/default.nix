{ lib
, stdenv
, fetchFromGitHub
, cmake
, libpng
, zlib
, qt4
, bison
, flex
, libGLU
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "seexpr";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "SeExpr";
    rev = "v${version}";
    sha256 = "sha256-r6mgyb/FGz4KYZOgLDgmIqjO+PSmneD3KUWjymZXtEk=";
  };

  cmakeFlags = [
    "-DENABLE_SSE4=OFF"
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libGLU libpng zlib qt4 python3Packages.pyqt4 python3Packages.boost bison flex ];

  meta = with lib; {
    description = "Embeddable expression evaluation engine from Disney Animation";
    homepage = "https://wdas.github.io/SeExpr/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
