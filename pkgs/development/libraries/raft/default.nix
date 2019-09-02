{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, libuv
}:

let
  pname = "raft";
  version = "0.9.5";

in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q49f5mmv6nr6dxhnp044xwc6jlczgh0nj0bl6718wiqh28411x0";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libuv ];

  meta = with stdenv.lib; {
    description = "C implementation of the Raft consensus protocol";
    homepage = "https://github.com/CanonicalLtd/raft";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
