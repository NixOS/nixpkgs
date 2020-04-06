{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  pname = "nanoflann";
  
  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "07vi3yn5y9zk9acdbxy954ghdml15wnyqfizzqwsw8zmc9bf30ih";
  };

  buildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/jlblancoc/nanoflann";
    license = stdenv.lib.licenses.bsd2;
    description = "Header only C++ library for approximate nearest neighbor search";
    platforms = stdenv.lib.platforms.unix;
  };
}
