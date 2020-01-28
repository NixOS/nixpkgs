{ stdenv, fetchFromGitHub, cmake, check, subunit }:
stdenv.mkDerivation rec {
  pname = "orcania";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "babelouest";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zp2rk267dfmfap6qsyn7maivrpid8s3rkicwk1q5v6j20cgh1f8";
  };

  nativeBuildInputs = [ cmake ];

  checkInputs = [ check subunit ];

  cmakeFlags = [ "-DBUILD_ORCANIA_TESTING=on" ];

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH="$(pwd)''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
    export DYLD_FALLBACK_LIBRARY_PATH="$(pwd):$DYLD_FALLBACK_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Potluck with different functions for different purposes that can be shared among C programs";
    homepage = "https://github.com/babelouest/orcania";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ johnazoidberg ];
  };
}
