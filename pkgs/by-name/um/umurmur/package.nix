{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  openssl,
  protobufc,
  libconfig,
}:

stdenv.mkDerivation rec {
  pname = "umurmur";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "umurmur";
    repo = "umurmur";
    rev = version;
    sha256 = "sha256-q5k1Lv+/Kz602QFcdb/FoWWaH9peAQIf7u1NTCWKTBM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    openssl
    protobufc
    libconfig
  ];

  patches = [
    # https://github.com/umurmur/umurmur/issues/175
    (fetchpatch {
      url = "https://github.com/umurmur/umurmur/commit/2c7353eaabb88544affc0b0d32d2611994169159.patch";
      hash = "sha256-Ws4Eqb6yI5Vnwfeu869hDtisi8NcobEK6dC7RWnWSJA=";
    })
  ];

  configureFlags = [
    "--with-ssl=openssl"
    "--enable-shmapi"
  ];

  meta = with lib; {
    description = "Minimalistic Murmur (Mumble server)";
    license = licenses.bsd3;
    homepage = "https://github.com/umurmur/umurmur";
    platforms = platforms.all;
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
    mainProgram = "umurmurd";
  };
}
