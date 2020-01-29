{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, libtool }:

stdenv.mkDerivation rec {
  version = "3.2p3";
  pname = "libow";

  src = fetchFromGitHub {
    owner = "owfs";
    repo = "owfs";
    rev = "v${version}";
    sha256 = "02l3r4ixhicph5iqxdjanck2gbqkfs9vnnac112bzlvlw3x9r03m";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];

  meta = with stdenv.lib; {
    description = "1-Wire File System full library";
    homepage = https://owfs.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ disserman ];
    platforms = platforms.unix;
  };

  buildInputs = [ libtool ];

  preConfigure = "./bootstrap";

  configureFlags = [
      "--disable-owtcl"
      "--disable-owphp"
      "--disable-owpython"
      "--disable-zero"
      "--disable-owshell"
      "--disable-owhttpd"
      "--disable-owftpd"
      "--disable-owserver"
      "--disable-owperl"
      "--disable-owtcl"
      "--disable-owtap"
      "--disable-owmon"
      "--disable-owexternal"
    ];
}
