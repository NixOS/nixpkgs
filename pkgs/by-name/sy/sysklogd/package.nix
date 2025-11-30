{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "sysklogd";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "sysklogd";
    rev = "v${version}";
    hash = "sha256-HwzqWZox5qc/TvCafx4XjA4njQhcHBS0gZthqPzONHk=";
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
}
