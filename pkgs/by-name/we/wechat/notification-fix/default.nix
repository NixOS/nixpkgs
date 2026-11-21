{
  stdenv,
  dbus,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "wechat-notification-fix";
  version = "1";
  src = ./.;
  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];
  nativeCheckInputs = [ dbus ];

  dontConfigure = true;
  buildPhase = ''
    runHook preBuild

    $CC -Wall -Wextra -Werror -fPIC -shared notification-fix.c \
      $(pkg-config --cflags --libs dbus-1) -ldl -pthread -o libwechat-notification-fix.so

    runHook postBuild
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    $CC -Wall -Wextra -Werror test.c $(pkg-config --cflags --libs dbus-1) \
      -ldl -pthread -o test-notifications
    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- \
      env LD_PRELOAD=$PWD/libwechat-notification-fix.so ./test-notifications

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 libwechat-notification-fix.so "$out/lib/libwechat-notification-fix.so"

    runHook postInstall
  '';
}
