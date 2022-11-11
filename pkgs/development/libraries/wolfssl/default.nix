{ lib
, stdenv
, fetchFromGitHub
, Security
, autoreconfHook
, openssl
}:

stdenv.mkDerivation rec {
  pname = "wolfssl";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "wolfSSL";
    repo = "wolfssl";
    rev = "v${version}-stable";
    sha256 = "sha256-d8DDyEsK35WK7c0udZI5HxQLO+mbod8hlbSoa3IWWS0=";
  };

  postPatch = ''
    patchShebangs ./scripts
    # ocsp tests require network access
    sed -i -e '/ocsp\.test/d' -e '/ocsp-stapling\.test/d' scripts/include.am
    # ensure test detects musl-based systems too
    substituteInPlace scripts/ocsp-stapling2.test \
      --replace '"linux-gnu"' '"linux-"'
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

  propagatedBuildInputs = [ ] ++ lib.optionals stdenv.isDarwin [ Security ];
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
