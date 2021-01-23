{ lib, stdenv, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "libx86emu";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "wfeldt";
    repo = "libx86emu";
    rev = version;
    sha256 = "104xqc6nj9rpi7knl3dfqvasf087hlz2n5yndb1iycw35a6j509b";
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

  meta = with lib; {
    description = "x86 emulation library";
    license = licenses.bsd2;
    homepage = "https://github.com/wfeldt/libx86emu";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
