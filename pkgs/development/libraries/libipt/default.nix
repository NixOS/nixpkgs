{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "1i6jmv345rqd88qmap6iqbaph4pkd6wbjgkixf22a80pj7cfm1s4";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Intel Processor Trace decoder library";
    homepage = "https://github.com/intel/libipt";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
