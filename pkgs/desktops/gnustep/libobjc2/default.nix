{ stdenv, lib, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libobjc2";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${version}";
    hash = "sha256-iDOVEDnTAfg9r3/kdHp7hzX2oIjO1ovaqgrlIV7V68M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Objective-C runtime for use with GNUstep";
    homepage = "http://gnustep.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ ashalkhakov matthewbauer ];
    platforms = platforms.unix;
  };
}
