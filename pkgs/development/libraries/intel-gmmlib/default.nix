{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "intel-gmmlib";
  version = "19.4.1";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = "${pname}-${version}";
    sha256 = "167g5rmrmzmfp4y4vghyxqi4schvvkwax3cvqgniqx8q1ib5l346";
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
