{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "libx86emu";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "wfeldt";
    repo = "libx86emu";
    rev = version;
    sha256 = "1a43xrgxyl1bawcyf4qnvasgjrmnl1npzlz07yz90vyg56x5c102";
  };

  nativeBuildInputs = [ perl ];

  postUnpack = "rm $sourceRoot/git2log";
  patchPhase = ''
    # VERSION is usually generated using Git
    echo "${version}" > VERSION
    substituteInPlace Makefile --replace "/usr" "/"
  '';

  buildFlags = [ "shared" ];
  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" ];

  meta = with stdenv.lib; {
    description = "x86 emulation library";
    license = licenses.bsd2;
    homepage = https://github.com/wfeldt/libx86emu;
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
