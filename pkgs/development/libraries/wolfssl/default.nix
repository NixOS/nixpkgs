{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "1gd613k4qh9yhl0d8yh0flqn2cvm9qb5pp2p0khk31b1fh1p4vin";
  };

  configureFlags = [ "--enable-all" ];

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
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
