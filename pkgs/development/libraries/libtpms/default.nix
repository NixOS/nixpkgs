{ stdenv
, fetchFromGitHub
, openssl
, libtool
, perl
, autoconf
, automake
, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "libtpms";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "v${version}";
    sha256 = "182i75igc6khwkidaqy8rbvxdz30z1p9g126mi3a0mvnwhg6g8rq";
  };

  configureFlags = [
    "--with-tpm2"
    "--with-openssl"
  ];

  buildInputs = [
    openssl
    libtool
  ];
  nativeBuildInputs = [
    perl
    autoconf
    automake
    autoreconfHook
  ];

  meta = with stdenv.lib; {
    description = "The libtpms library provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = "https://github.com/stefanberger/libtpms";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
