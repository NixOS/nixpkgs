{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "095agnk7r2sq5yas6c1ri8fmsl55n4l5hkl6j5l397p9nxvxvrkc";
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
