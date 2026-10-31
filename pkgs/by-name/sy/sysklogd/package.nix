{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sysklogd";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "sysklogd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VR8VohyGQyCbGBz8freZQeDIzIkXTtAyOvTCoTMOpAs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  meta = {
    description = "BSD syslog daemon with syslog()/syslogp() API replacement for Linux, RFC3164 + RFC5424";
    homepage = "https://github.com/troglobit/sysklogd";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aanderse ];
    platforms = lib.subtractLists lib.platforms.darwin lib.platforms.unix;
  };
})
