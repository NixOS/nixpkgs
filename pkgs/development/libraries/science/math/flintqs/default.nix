{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, gmp
}:

stdenv.mkDerivation rec {
  version = "1.0";
  pname = "flintqs";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "FlintQS";
    rev = "v${version}";
    sha256 = "1f0lnayz6j6qgasx8pbq61d2fqam0wwhsmh6h15l4vq58l1vvbwj";
  };

  preAutoreconf = ''
    touch ChangeLog
  '';

  buildInputs = [
    gmp
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  meta = with lib; {
    description = "Highly optimized multi-polynomial quadratic sieve for integer factorization";
    homepage = "https://github.com/sagemath/FlintQS";
    license = with licenses; [ gpl2 ];
    maintainers = teams.sage.members;
    mainProgram = "QuadraticSieve";
    platforms = platforms.all;
  };
}
