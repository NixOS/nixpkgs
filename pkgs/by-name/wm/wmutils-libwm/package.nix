{
  lib,
  stdenv,
  fetchFromGitHub,
  libxcb,
  xcb-util-cursor,
}:

stdenv.mkDerivation rec {
  pname = "wmutils-libwm";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "wmutils";
    repo = "libwm";
    tag = "v${version}";
    hash = "sha256-ROWRgTn33c5gH4ZdkwZ05rRg/Z9e2NppAQSNExSGZ4s=";
  };

  buildInputs = [
    libxcb
    xcb-util-cursor
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Small library for X window manipulation";
    homepage = "https://github.com/wmutils/libwm";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ bhougland ];
    platforms = lib.platforms.unix;
  };
}
