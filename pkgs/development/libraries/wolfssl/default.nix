{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, openssl
}:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "sha256-KteArWAgDohlqEYaNfzLPuBn6uy5ABA8vV/LRCVIPGA=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-34293.patch";
      url = "https://github.com/wolfSSL/wolfssl/commit/17d7098bf63b2716ef36a72754c7c93baacc9cee.patch";
      sha256 = "sha256-BgBMtOdyPV94aptlpt9IvcW9eJ0hlvlgp+H8LxQ2shs=";
    })
    (fetchpatch {
      name = "ecc-dh-improve-encrypted-memory-implementations.patch";
      url = "https://github.com/wolfSSL/wolfssl/commit/3c634e1f593586ff011623dd746f5a37d5659faf.patch";
      sha256 = "sha256-AUATjk/GIWuh+qUw21Ruzj9yzYU11wNiLvOzagkILcw=";
    })
  ];

  postPatch = ''
    patchShebangs ./scripts
    # ocsp tests require network access
    sed -i -e '/ocsp\.test/d' -e '/ocsp-stapling\.test/d' scripts/include.am
  '';

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

  doCheck = true;
  checkInputs = [ openssl ];

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
