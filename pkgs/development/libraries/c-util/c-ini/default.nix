{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja, c-stdaux, c-list, c-utf8, c-rbtree }:

stdenv.mkDerivation rec {
  pname = "c-ini";
  version = "unstable-2022-05-12";

  nativeBuildInputs = [
    meson ninja pkg-config
    c-stdaux c-list c-utf8 c-rbtree
  ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-ini";
    rev = "a44543e41ea1a86a85152f6fe7c56e4f86bb3ce6";
    sha256 = "18hy4zv89pkc5bwjl66ik0hwvpjzzh3akx8ji5h9r33j1ynlkva6";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-ini/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
