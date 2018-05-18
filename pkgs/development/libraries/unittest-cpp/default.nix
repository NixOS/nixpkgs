{stdenv, fetchFromGitHub, cmake}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "unittest-cpp-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "unittest-cpp";
    repo = "unittest-cpp";
    rev = "v${version}";
    sha256 = "0sxb3835nly1jxn071f59fwbdzmqi74j040r81fanxyw3s1azw0i";
  };

  buildInputs = [cmake];

  doCheck = false;

  meta = {
    homepage = https://github.com/unittest-cpp/unittest-cpp;
    description = "Lightweight unit testing framework for C++";
    license = licenses.mit;
    maintainers = [];
    platforms = stdenv.lib.platforms.unix;
  };
}
