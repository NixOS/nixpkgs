{ stdenv
, fetchFromGitHub
, autoreconfHook, pkgconfig
, zlib, libffi, elfutils, libdwarf
}:

stdenv.mkDerivation rec {
  pname = "ctypes.sh";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "taviso";
    repo = pname;
    rev = "v${version}";
    sha256 = "1wafyfhwd7nf7xdici0djpwgykizaz7jlarn0r1b4spnpjx1zbx4";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ zlib libffi elfutils libdwarf ];

  meta = with stdenv.lib; {
    description = "A foreign function interface for bash";
    homepage = "https://github.com/taviso/ctypes.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.unix;
  };
}
