{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "1aa51j0xnhi49izc8djya68l70jkjv25559pgybfb9sa4fa4gz97";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-37155.part-1.patch";
      url = "https://github.com/wolfSSL/wolfssl/commit/73076940af8904f98eee085994c176fe1876b95a.patch";
      sha256 = "1fdg6c49njhxn6yljpqrhrv2s6ci6hyw01xjs42s09ly3xvf2fcx";
    })
    (fetchpatch {
      name = "CVE-2021-37155.part-2.patch";
      url = "https://github.com/wolfSSL/wolfssl/commit/822aa92fccf77558e250131c1c6e9bb84d07afe8.patch";
      sha256 = "1n7774hy9ybbxmg8dldqnhw279k7fkxwvw1s2mjjhkzra9w5x2zy";
    })
  ];

  # almost same as Debian but for now using --enable-all --enable-reproducible-build instead of --enable-distro to ensure options.h gets installed
  configureFlags = [ "--enable-all" "--enable-reproducible-build" "--enable-pkcs11" "--enable-tls13" "--enable-base64encode" ];

  outputs = [ "out" "dev" "doc" "lib" ];

  nativeBuildInputs = [ autoreconfHook ];

  postInstall = ''
     # fix recursive cycle:
     # wolfssl-config points to dev, dev propagates bin
     moveToOutput bin/wolfssl-config "$dev"
     # moveToOutput also removes "$out" so recreate it
     mkdir -p "$out"
  '';

  meta = with lib; {
    description = "A small, fast, portable implementation of TLS/SSL for embedded devices";
    homepage    = "https://www.wolfssl.com/";
    platforms   = platforms.all;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ mcmtroffaes ];
  };
}
