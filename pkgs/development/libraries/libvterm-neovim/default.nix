{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation rec {
  pname = "libvterm-neovim";
  version = "2018-11-26";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "f600f523545b7d4018ebf320e3273795dbe43c8a";
    sha256 = "08lxd8xs9cg4axgq6bkb7afjxg3s29s1a3niqqm4wjb7iyi2jx5b";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ libtool ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ stdenv.lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = http://www.leonerd.org.uk/code/libvterm/;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.unix;
  };
}
