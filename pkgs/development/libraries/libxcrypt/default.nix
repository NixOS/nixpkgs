{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, perl }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.28";

  src = fetchFromGitHub {
    owner = "besser82";
    repo = "libxcrypt";
    rev = "v${version}";
    sha256 = "sha256-Ohf+RCOXnoCxAFnXXV9e2TCqpfZziQl+FGJTGDSQTF0=";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = [
    "--disable-werror"
  ];

  nativeBuildInputs = [ autoconf automake libtool pkg-config perl ];

  doCheck = true;

  meta = with lib; {
    description = "Extended crypt library for descrypt, md5crypt, bcrypt, and others";
    homepage = "https://github.com/besser82/libxcrypt/";
    platforms = platforms.all;
    maintainers = with maintainers; [ dottedmag ];
    license = licenses.lgpl21Plus;
  };
}
