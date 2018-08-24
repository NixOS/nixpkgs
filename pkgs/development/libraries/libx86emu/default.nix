{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "libx86emu-${version}";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "wfeldt";
    repo = "libx86emu";
    rev = version;
    sha256 = "12rlkwnl5zgmmpm6n6cqnkyhkji4jw1d27y8x1krvlpi1z4bjidx";
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
