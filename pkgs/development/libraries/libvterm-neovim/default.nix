{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation rec {
  name = "neovim-libvterm-${version}";
  version = "2017-11-05";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "4ca7ebf7d25856e90bc9d9cc49412e80be7c4ea8";
    sha256 = "05kyvvz8af90mvig11ya5xd8f4mbvapwyclyrihm9lwas706lzf6";
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
