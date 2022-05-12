{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "libkqueue";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "mheily";
    repo = "libkqueue";
    rev = "v${version}";
    sha256 = "sha256-YKKBHOxjUS7+/ib4gcR7EYjjVOwhHVksYasLhErdV8s=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "kqueue(2) compatibility library";
    homepage = "https://github.com/mheily/libkqueue";
    license = licenses.bsd2;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux;
  };
}
