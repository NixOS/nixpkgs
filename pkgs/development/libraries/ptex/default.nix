{ lib, stdenv, fetchFromGitHub, zlib, cmake }:

stdenv.mkDerivation rec
{
  pname = "ptex";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "wdas";
    repo = "ptex";
    rev = "v${version}";
    sha256 = "sha256-PR1ld9rXmL6BK4llznAsD5PNvi3anFMz2i9NDsG95DQ=";
  };

  outputs = [ "bin" "dev" "out" "lib" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Per-Face Texture Mapping for Production Rendering";
    homepage = "http://ptex.us/";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [ maintainers.guibou ];
  };
}
