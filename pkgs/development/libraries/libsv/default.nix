{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libsv";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "uael";
    repo = "sv";
    rev = "v${version}";
    sha256 = "sha256-icvGQi6FNSZXNGs2oLiUKu6rrVsWcXh1r91kycGjnwY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Public domain cross-platform semantic versioning in C99";
    homepage = "https://github.com/uael/sv";
    license = licenses.unlicense;
    maintainers = [];
    platforms = platforms.unix;
  };
}
