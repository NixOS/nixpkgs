{ buildPecl, lib, pkgs, php }:
buildPecl {
  pname = "event";

  version = "3.0.2";
  sha256 = "1ws4l014z52vb23xbsfj6viwkf7fmh462af639xgbp0n6syf77dq";

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

  nativeBuildInputs = [ pkgs.pkg-config ];
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
