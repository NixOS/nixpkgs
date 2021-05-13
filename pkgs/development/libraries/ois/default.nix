{ stdenv, lib, fetchFromGitHub, cmake, libX11, Cocoa, IOKit, Kernel }:

stdenv.mkDerivation rec {
  pname = "ois";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "wgois";
    repo = "OIS";
    rev = "v${version}";
    sha256 = "sha256:0nkh0zrsbyv47c0i0vhdna3jsnvs69pb1svg75avxw6z7kwskgla";
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
