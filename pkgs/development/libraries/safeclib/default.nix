{ stdenv, fetchFromGitHub, autoreconfHook, perl }:

stdenv.mkDerivation rec {
  pname = "safeclib";
  version = "08112019";

  src = fetchFromGitHub {
    owner = "rurban";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1wlr3w65q0hlisg4xkhirva0bp63y7sxg03vkvwz4vymk0xmxkgn";
  };

  buildInputs = [
    perl
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rurban/safeclib";
    description = "An implementation of the secure C11 Annex K functions";
    license = licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = platforms.linux;
  };
}
