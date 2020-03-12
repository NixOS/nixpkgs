{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libscrypt";
  version = "1.21";

  src = fetchFromGitHub {
    owner = "technion";
    repo = "libscrypt";
    rev = "v${version}";
    sha256 = "1d76ys6cp7fi4ng1w3mz2l0p9dbr7ljbk33dcywyimzjz8bahdng";
  };

  buildFlags = stdenv.lib.optional stdenv.isDarwin "LDFLAGS= CFLAGS_EXTRA=";

  installFlags = [ "PREFIX=$(out)" ];
  installTargets = stdenv.lib.optional stdenv.isDarwin "install-osx";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Shared library that implements scrypt() functionality";
    homepage = https://lolware.net/2014/04/29/libscrypt.html;
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.unix;
  };
}
