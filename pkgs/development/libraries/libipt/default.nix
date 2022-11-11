{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "sha256-W7Hvc2zkmR6FdPGsymWXtm66BiHLcW9r7mywHjabeLc=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
