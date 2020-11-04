{ buildPecl, lib, pkgs, php }:
buildPecl {
  pname = "event";

  version = "3.0.0";
  sha256 = "1k35qwcf4qz8617b4riy7bp0vna1j3ds0k9j52hlm7qrhww2yxqn";

  configureFlags = [
    "--with-event-libevent-dir=${pkgs.libevent.dev}"
    "--with-event-core"
    "--with-event-extra"
    "--with-event-pthreads"
  ];

  postPhpize = ''
    substituteInPlace configure --replace \
      'as_fn_error $? "Couldn'\'''t find $phpincludedir/sockets/php_sockets.h. Please check if sockets extension installed" "$LINENO" 5' \
      ':'
  '';

  nativeBuildInputs = [ pkgs.pkgconfig ];
  buildInputs = with pkgs; [ openssl libevent ];
  internalDeps = [ php.extensions.sockets ];

  meta = with pkgs.lib; {
    description = ''
      This is an extension to efficiently schedule I/O, time and signal based
      events using the best I/O notification mechanism available for specific platform.
    '';
    license = licenses.php301;
    homepage = "https://bitbucket.org/osmanov/pecl-event/";
    maintainers = teams.php.members;
  };
}
