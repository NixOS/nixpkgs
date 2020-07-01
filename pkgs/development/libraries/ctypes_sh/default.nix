{ stdenv
, fetchFromGitHub
, autoreconfHook, pkgconfig
, zlib, libffi, elfutils, libdwarf
}:

stdenv.mkDerivation rec {
  pname = "ctypes.sh";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "taviso";
    repo = pname;
    rev = "v${version}";
    sha256 = "07rqbdxw33h92mllh0srymjjx52mddafs3jyzqpsflq3v0l0dk37";
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
