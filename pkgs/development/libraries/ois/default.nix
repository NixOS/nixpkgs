{ stdenv, lib, fetchFromGitHub, cmake, libX11, Cocoa, IOKit, Kernel }:

stdenv.mkDerivation rec {
  pname = "ois";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "wgois";
    repo = "OIS";
    rev = "v${version}";
    sha256 = "0g8krgq5bdx2rw7ig0xva4kqv4x815672i7z6lljp3n8847wmypa";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libX11 ] ++ lib.optionals stdenv.isDarwin [ Cocoa IOKit Kernel ];

  meta = with lib; {
    description = "Object-oriented C++ input system";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    license = licenses.zlib;
  };
}
