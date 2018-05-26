{ stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  name = "libx86emu-${version}";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "wfeldt";
    repo = "libx86emu";
    rev = version;
    sha256 = "120a01jrrd4rwwjfr5f612xq9hbh35c87a6wnqn7zzw3fqydc2lw";
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
