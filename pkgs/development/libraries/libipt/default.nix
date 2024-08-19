{ lib, stdenv, fetchFromGitHub, cmake, freebsd }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "sha256-tyOheitSlccf/n3mklGL2oAKLBKYT60LSLre9/G/b9Q=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.isFreeBSD freebsd.libstdthreads;

  meta = with lib; {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
