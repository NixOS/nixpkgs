{ stdenv, lib, fetchFromGitHub, libtool }:

stdenv.mkDerivation rec {
  pname = "pystring";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "imageworks";
    repo = "pystring";
    rev = "v${version}";
    sha256 = "1w31pjiyshqgk6zd6m3ab3xfgb0ribi77r6fwrry2aw8w1adjknf";
  };

  nativeBuildInputs = [ libtool ];

  patches = [ ./makefile.patch ];

  doCheck = true;
  checkTarget = "test";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/imageworks/pystring/";
    description = "A collection of C++ functions which match the interface and behavior of python's string class methods using std::string";
    license = licenses.bsd3;
    maintainers = [ maintainers.rytone ];
    platforms = platforms.unix;
  };
}
