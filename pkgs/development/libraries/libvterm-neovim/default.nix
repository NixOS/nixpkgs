{ lib
, stdenv
, fetchFromGitHub
, perl
, libtool
}:

stdenv.mkDerivation (drv: {
  pname = "libvterm-neovim";
  version = "0.3";
  src = builtins.fetchTarball {
    url = "https://www.leonerd.org.uk/code/libvterm/libvterm-${drv.version}.tar.gz";
    sha256 = "0zg6sn5brwrnqaab883pdj0l2swk5askbbwbdam0zq55ikbrzgar";
  };

  nativeBuildInputs = [ perl libtool ];

  makeFlags = [ "PREFIX=$(out)" ]
    ++ lib.optional stdenv.isDarwin "LIBTOOL=${libtool}/bin/libtool";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "VT220/xterm/ECMA-48 terminal emulator library";
    homepage = "http://www.leonerd.org.uk/code/libvterm/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.unix;
  };
})
