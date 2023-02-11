{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "unittest-cpp";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "unittest-cpp";
    repo = "unittest-cpp";
    rev = "v${version}";
    sha256 = "0sxb3835nly1jxn071f59fwbdzmqi74j040r81fanxyw3s1azw0i";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = false;

  meta = {
    homepage = "https://github.com/unittest-cpp/unittest-cpp";
    description = "Lightweight unit testing framework for C++";
    license = lib.licenses.mit;
    maintainers = [];
    platforms = lib.platforms.unix;
  };
}
