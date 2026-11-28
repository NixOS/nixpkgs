{
  buildPecl,
  lib,
  php,
  pkg-config,
  openssl,
  libevent,
}:
buildPecl {
  pname = "event";

  version = "3.2.0";
  sha256 = "sha256-+z1OPJ/ceRJSdPK0ZGFJKSPt7GtIntcHeXP35l9B3Bw=";

  configureFlags = [
    "--with-event-libevent-dir=${libevent.dev}"
    "--with-event-core"
    "--with-event-extra"
    "--with-event-pthreads"
  ];

  postPhpize = ''
    substituteInPlace configure --replace \
      'as_fn_error $? "Couldn'\'''t find $phpincludedir/sockets/php_sockets.h. Please check if sockets extension installed" "$LINENO" 5' \
      ':'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    libevent
  ];
  internalDeps = [ php.extensions.sockets ];

  meta = {
    description = "Efficiently schedule I/O, time and signal based events using the best I/O notification mechanism available";
    license = lib.licenses.php301;
    homepage = "https://bitbucket.org/osmanov/pecl-event/";
    teams = [ lib.teams.php ];
  };
}
