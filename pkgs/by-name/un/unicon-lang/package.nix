{
  lib,
  stdenv,
  libX11,
  libxcrypt,
  fetchFromGitHub,
  coreutils,
  libpng,
  xorg,
  freetype,
  zlib,
  libjpeg,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unicon-lang";
  version = "13.2-unstable-2025-06-02";

  src = fetchFromGitHub {
    owner = "uniconproject";
    repo = "unicon";
    rev = "cf3b53b9578a004a52146a7adadc2a9409426624";
    hash = "sha256-+4HSLnVTLdBVnKqWhOrx4XHTs3mRlM6n2ISQ+C1g3Ns=";
  };

  postPatch = ''
    substituteInPlace tests/Makefile --replace-fail "/bin/echo" "${coreutils}/bin/echo"
    substituteInPlace tests/Makedefs --replace-fail "/bin/echo" "${coreutils}/bin/echo"
  '';

  buildInputs = [
    libxcrypt
    # compression
    zlib
    # graphics
    libX11
    libjpeg
    libpng
    xorg.libXft
    freetype
    # ssl
    openssl
  ];

  hardeningDisable = [ "fortify" ];

  # Issues when building plugins and running tests on aarch
  enableParallelBuilding = false;

  doCheck = true;
  checkTarget = "Test";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/unicon -version
    runHook postInstallCheck
  '';

  meta = {
    description = "Very high level, goal-directed, object-oriented, general purpose applications language";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    homepage = "http://www.unicon.org";
  };
})
