{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libscrypt";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "technion";
    repo = "libscrypt";
    rev = "v${version}";
    sha256 = "sha256-QWWqC10bENemG5FYEog87tT7IxDaBJUDqu6j/sO3sYE=";
  };

  buildFlags = lib.optional stdenv.isDarwin "LDFLAGS= CFLAGS_EXTRA=";

  installFlags = [ "PREFIX=$(out)" ];
  installTargets = lib.optional stdenv.isDarwin "install-osx";

  doCheck = true;

  meta = with lib; {
    description = "Shared library that implements scrypt() functionality";
    homepage = "https://lolware.net/2014/04/29/libscrypt.html";
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}
