{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "intel-gmmlib-${version}";
  version = "19.2.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = name;
    sha256 = "174bpkmr20ng9h9xf9fy85lj3pw6ysmbhcvhjfmj30xg3hs2ar3k";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/gmmlib;
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
