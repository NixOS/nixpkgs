{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "xmake-core-sv";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "xmake-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-icvGQi6FNSZXNGs2oLiUKu6rrVsWcXh1r91kycGjnwY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "Public domain cross-platform semantic versioning in c99";
    homepage = "https://github.com/xmake-io/xmake-core-sv";
    license = licenses.unlicense;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
  };
}
