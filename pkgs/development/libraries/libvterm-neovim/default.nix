{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation {
  pname = "libvterm-neovim";
  version = "2019-10-08";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "7c72294d84ce20da4c27362dbd7fa4b08cfc91da";
    sha256 = "111qyxq33x74dwdnqcnzlv9j0n8hxyribd6ppwcsxmyrniyw9qrk";
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
