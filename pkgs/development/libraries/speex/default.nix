{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  fftw,
  speexdsp,
  withFft ? !stdenv.hostPlatform.isMinGW,
}:

stdenv.mkDerivation rec {
  pname = "speex";
  version = "1.2.1";

  src = fetchurl {
    url = "http://downloads.us.xiph.org/releases/speex/speex-${version}.tar.gz";
    sha256 = "sha256-S0TU8rOKNwotmKeDKf78VqDPk9HBvnACkhe6rmYo/uo=";
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

  configureFlags = lib.optionals withFft [
    "--with-fft=gpl-fftw3"
  ];

  meta = with lib; {
    homepage = "https://www.speex.org/";
    description = "An Open Source/Free Software patent-free audio compression format designed for speech";
    license = licenses.bsd3;
    platforms = platforms.unix ++ platforms.windows;
  };
}
