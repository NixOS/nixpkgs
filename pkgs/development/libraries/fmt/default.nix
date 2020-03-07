{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "fmt";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = version;
    sha256 = "1ngb2fd7c2jnxi3x5kjgxmpixmyc737f77vibij43dl77ybiaihi";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # for tests
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Small, safe and fast formatting library";
    longDescription = ''
      fmt (formerly cppformat) is an open-source formatting library. It can be
      used as a fast and safe alternative to printf and IOStreams.
    '';
    homepage = http://fmtlib.net/;
    downloadPage = https://github.com/fmtlib/fmt/;
    maintainers = [ maintainers.jdehaas ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
