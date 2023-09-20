{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "sha256-RuahOkDLbac9bhXn8QSf7lMRw11PIpXQo3eaQ9N4Rtc=";
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
