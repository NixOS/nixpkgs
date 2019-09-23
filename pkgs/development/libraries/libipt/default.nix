{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libipt";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libipt";
    rev = "v${version}";
    sha256 = "19y1lk5z1rf8xmr08m8zrpjkgr5as83b96xyaxwn67m2wz58mpmh";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Intel Processor Trace decoder library";
    homepage = https://github.com/intel/libipt;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
