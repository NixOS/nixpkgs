{ stdenv, fetchFromGitHub
, cmake
, cppunit
, openssl
, pkgconfig
, zlib

, withTests ? true
}:

stdenv.mkDerivation rec {
  pname = "rct";
  version = "unstable-2019-07-21";

  src = fetchFromGitHub {
    owner = "andersbakken";
    repo = "rct";
    rev = "7bd3732c232a1843990f67f41f1d86cb2c16f341";
    sha256 = "13lb6hsgys257a1ry0ngwl0gm979947x8fbrl6idjzdjbzq8jh4n";
  };

  outputs = [ "out" "dev" ];

  cmakeFlags = [ "-DRCT_WITH_TESTS=${if withTests then "ON" else "OFF"}" ];

  nativeBuildInputs = [ cmake cppunit pkgconfig ];
  buildInputs = [ openssl zlib ];

  enableParallelBuilding = true;

  doCheck = withTests;
  # put librct.{so,dylib} on path
  preCheck = ''
    export LD_LIBRARY_PATH=$PWD:$LD_LIBRARY_PATH
  '';

  meta = with stdenv.lib; {
    description= "A set of c++ tools that provide nicer (more Qt-like) APIs on top of stl classes with a friendly license";
    homepage = https://github.com/Andersbakken/rct;
    license = licenses.bsdOriginal;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jonringer ];
  };

}
