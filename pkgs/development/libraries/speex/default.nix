{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  fftw,
  speexdsp,
  testers,
  withFft ? !stdenv.hostPlatform.isMinGW,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "speex";
  version = "1.2.1";

  src = fetchurl {
    url = "https://downloads.us.xiph.org/releases/speex/speex-${finalAttrs.version}.tar.gz";
    hash = "sha256-S0TU8rOKNwotmKeDKf78VqDPk9HBvnACkhe6rmYo/uo=";
  };

  postPatch = ''
    sed -i '/AC_CONFIG_MACRO_DIR/i PKG_PROG_PKG_CONFIG' configure.ac
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = lib.optionals withFft [ fftw ] ++ [ speexdsp ];

  # TODO: Remove this will help with immediate backward compatibility
  propagatedBuildInputs = [ speexdsp ];

  strictDeps = true;

  configureFlags = lib.optionals withFft [
    "--with-fft=gpl-fftw3"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.speex.org/";
    description = "Open Source/Free Software patent-free audio compression format designed for speech";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    pkgConfigModules = [ "speex" ];
  };
})
