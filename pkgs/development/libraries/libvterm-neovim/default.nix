{ stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation {
  pname = "libvterm-neovim";
  version = "2019-08-28";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "libvterm";
    rev = "1aa95e24d8f07a396aa80b7cd52f93e2b5bcca79";
    sha256 = "0vjd397lqrfv4kc79i5izva4bynbymx3gllkg281fnk0b15vxfif";
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
