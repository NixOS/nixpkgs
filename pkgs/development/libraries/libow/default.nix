{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, libtool }:

stdenv.mkDerivation rec {
  version = "3.2p4";
  pname = "libow";

  src = fetchFromGitHub {
    owner = "owfs";
    repo = "owfs";
    rev = "v${version}";
    sha256 = "0dln1ar7bxwhpi36sccmpwapy7iz4j097rbf02mgn42lw5vrcg3s";
  };

  nativeBuildInputs = [ autoconf automake pkg-config ];

  meta = with lib; {
    description = "1-Wire File System full library";
    homepage = "https://owfs.org/";
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
