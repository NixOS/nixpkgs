{ stdenv, lib, fetchFromGitHub, cmake, libX11, Cocoa, IOKit, Kernel }:

stdenv.mkDerivation rec {
  pname = "ois";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "wgois";
    repo = "OIS";
    rev = "v${version}";
    sha256 = "sha256-ir6p+Tzf8L5VOW/rsG4yelsth7INbhABO2T7pfMHcFo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libX11 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa IOKit Kernel ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "Object-oriented C++ input system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
