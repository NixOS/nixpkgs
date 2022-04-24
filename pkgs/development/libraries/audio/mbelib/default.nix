{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "mbelib";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "szechyjs";
    repo = "mbelib";
    rev = "v${version}";
    sha256 = "0v6b7nf8fgxy7vzgcwffqyql5zhldrz30c88k1ylbjp78hwh4rif";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$PWD
    export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH''${DYLD_LIBRARY_PATH:+:}$PWD
  '';

  meta = with lib; {
    description = "P25 Phase 1 and ProVoice vocoder";
    homepage = "https://github.com/szechyjs/mbelib";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andrew-d ];
  };
}
