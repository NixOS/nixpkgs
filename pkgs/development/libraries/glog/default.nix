{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "glog-${version}";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "Google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "0ym5g15m7c8kjfr2c3zq6bz08ghin2d1r1nb6v2vnkfh1vn945x1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/google/glog;
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
