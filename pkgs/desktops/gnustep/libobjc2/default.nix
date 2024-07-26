{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libobjc2";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "gnustep";
    repo = "libobjc2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iDOVEDnTAfg9r3/kdHp7hzX2oIjO1ovaqgrlIV7V68M=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Objective-C runtime for use with GNUstep";
    homepage = "https://gnustep.github.io/";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ashalkhakov matthewbauer dblsaiko ];
    platforms = platforms.unix;
  };
})
