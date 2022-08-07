{ stdenv, lib, fetchFromGitHub, cmake, gflags, perl }:

stdenv.mkDerivation rec {
  pname = "glog";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
  };

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ gflags ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  # TODO: Re-enable Darwin tests once we're on a release that has https://github.com/google/glog/issues/709#issuecomment-960381653 fixed
  doCheck = !stdenv.isDarwin;
  # There are some non-thread safe tests that can fail
  enableParallelChecking = false;
  checkInputs = [ perl ];

  meta = with lib; {
    homepage = "https://github.com/google/glog";
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [ nh2 r-burns ];
  };
}
