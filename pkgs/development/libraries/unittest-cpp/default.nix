{stdenv, fetchFromGitHub, cmake}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "unittest-cpp-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "unittest-cpp";
    repo = "unittest-cpp";
    rev = "v${version}";
    sha256 = "1sva2bm90z4vmwwvp0af82f7p4sdq5j2jjqzhs2ppihdkggn62d1";
  };

  buildInputs = [cmake];

  doCheck = false;

  meta = {
    homepage = "https://github.com/unittest-cpp/unittest-cpp";
    description = "Lightweight unit testing framework for C++";
    license = licenses.mit;
    maintainers = [maintainers.tohl];
    platforms = stdenv.lib.platforms.unix;
  };
}
