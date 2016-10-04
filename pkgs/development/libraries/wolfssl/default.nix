{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "wolfssl-${version}";
  version = "3.9.8";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}";
    sha256 = "0b1a9rmzpzjblj0gsrzas2aljivd0gfimcsj8gjl80ng25zgmaxr";
  };

  outputs = [ "out" "dev" "doc" "lib" ];

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
     # fix recursive cycle:
     # wolfssl-config points to dev, dev propagates bin
     moveToOutput bin/wolfssl-config "$dev"
     # moveToOutput also removes "$out" so recreate it
     mkdir -p "$out"
  '';

  meta = with stdenv.lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage    = "https://www.wolfssl.com/";
    platforms   = platforms.all;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
