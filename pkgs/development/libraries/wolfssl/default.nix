{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "sha256-rv9D+P42RMH1O4YLQbZIEkD6KQfs8KgYjhnHeA9vQqE=";
  };

  # Almost same as Debian but for now using --enable-all --enable-reproducible-build instead of --enable-distro to ensure options.h gets installed
  configureFlags = [
    "--enable-all"
    "--enable-base64encode"
    "--enable-pkcs11"
    "--enable-writedup"
    "--enable-reproducible-build"
    "--enable-tls13"
  ];

  outputs = [
    "dev"
    "doc"
    "lib"
    "out"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  postInstall = ''
     # fix recursive cycle:
     # wolfssl-config points to dev, dev propagates bin
     moveToOutput bin/wolfssl-config "$dev"
     # moveToOutput also removes "$out" so recreate it
     mkdir -p "$out"
  '';

  meta = with lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage = "https://www.wolfssl.com/";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
  };
}
