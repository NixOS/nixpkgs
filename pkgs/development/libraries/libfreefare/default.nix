{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  libnfc,
  openssl,
  libobjc ? null,
  IOKit,
  Security,
}:

stdenv.mkDerivation {
  pname = "libfreefare";
  version = "0.4.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libfreefare/libfreefare-0.4.0.tar.bz2";
    sha256 = "0r5wfvwgf35lb1v65wavnwz2wlfyfdims6a9xpslf4lsm4a1v8xz";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [
      libnfc
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
      IOKit
      Security
    ];

  meta = with lib; {
    description = "Libfreefare project aims to provide a convenient API for MIFARE card manipulations";
    license = licenses.lgpl3;
    homepage = "https://github.com/nfc-tools/libfreefare";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.unix;
  };
}
