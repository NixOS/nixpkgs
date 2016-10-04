{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "libuchardet-${version}";

  version = "0.0.5";

  src = fetchFromGitHub {
    owner  = "BYVoid";
    repo   = "uchardet";
    rev    = "v${version}";
    sha256 = "0rkym5bhq3hn7623fy0fggw0qaghha71k8bi41ywqd2lchpahrrm";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage    = https://www.byvoid.com/zht/project/uchardet;
    license     = licenses.mpl11;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
