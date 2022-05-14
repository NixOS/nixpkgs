{ lib, stdenv, fetchFromGitHub, pkg-config, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "c-stdaux";
  version = "unstable-2022-05-16";

  nativeBuildInputs = [ meson ninja pkg-config ];

  src = fetchFromGitHub {
    owner = "c-util";
    repo = "c-stdaux";
    rev = "adda5ff3e9d98648a4e01ad800fafd584e4640ce";
    sha256 = "10rqvchbsbqq82vb9hqhhfrggm7b75szhacbal2xp1cn47f8gcax";
  };

  meta = with lib; {
    description = "Common Utility Libraries for C11";
    homepage    = "https://c-util.github.io/c-stdaux/";
    license     = licenses.asl20;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ xaverdh ];
  };
}
