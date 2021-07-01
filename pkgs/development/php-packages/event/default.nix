{ buildPecl, lib, php, pkg-config, openssl, libevent }:
buildPecl {
  pname = "event";

  version = "3.0.5";
  sha256 = "0q5a83mcl97cyry5rd85j5xsjvflnki6s5cm56igjm0szxvgj39c";

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
  buildInputs = [ openssl libevent ];
  internalDeps = [ php.extensions.sockets ];

  meta = with lib; {
    description = ''
      This is an extension to efficiently schedule I/O, time and signal based
      events using the best I/O notification mechanism available for specific platform.
    '';
    license = licenses.php301;
    homepage = "https://bitbucket.org/osmanov/pecl-event/";
    maintainers = teams.php.members;
  };
}
