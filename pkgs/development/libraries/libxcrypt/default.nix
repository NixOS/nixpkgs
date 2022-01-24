{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, pkg-config, perl }:

stdenv.mkDerivation rec {
  pname = "libxcrypt";
  version = "4.4.18";

  src = fetchFromGitHub {
    owner = "besser82";
    repo = "libxcrypt";
    rev = "v${version}";
    sha256 = "4015bf1b3a2aab31da5a544424be36c1a0f0ffc1eaa219c0e7b048e4cdcbbfe1";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

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
