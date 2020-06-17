{ stdenv
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/sagemath/FlintQS";
    description = "Highly optimized multi-polynomial quadratic sieve for integer factorization";
    license = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.all;
  };
}
