{ stdenv, fetchFromGitHub, autoreconfHook, perl }:

stdenv.mkDerivation rec {
  name = "glog-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "1xd3maiipfbxmhc9rrblc5x52nxvkwxp14npg31y5njqvkvzax9b";
  };

  nativeBuildInputs = [ autoreconfHook ];

  checkInputs = [ perl ];
  doCheck = false; # fails with "Mangled symbols (28 out of 380) found in demangle.dm"

  meta = with stdenv.lib; {
    homepage = https://github.com/google/glog;
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
  };
}
