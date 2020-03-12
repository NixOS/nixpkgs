{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation {
  pname = "libvterm-neovim";
  # Releases are not tagged, look at commit history to find latest release
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "65dbda3ed214f036ee799d18b2e693a833a0e591";
    sha256 = "0r6yimzbkgrsi9aaxwvxahai2lzgjd1ysblr6m6by5w459853q3n";
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
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
}
