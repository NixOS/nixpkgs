{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.3.2";
  pname = "nanoflann";

  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "0lq1zqwjvk8wv15hd7aw57jsqbvv45cwb8ngdh1d2iyw5rvnbhsn";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
  ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = "https://github.com/jlblancoc/nanoflann";
    license = lib.licenses.bsd2;
    description = "Header only C++ library for approximate nearest neighbor search";
    platforms = lib.platforms.unix;
  };
}
