{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  gevent,
}:
let
  version = "2.1";
  hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
in
buildPythonPackage rec {
  pname = "gevent-eventemitter";
  inherit version;

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "gevent-eventemitter";
    tag = "v${version}";
    inherit hash;
  };

  dependencies = [
    gevent
  ];

  meta = {
    description = "EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ weirdrock ];
  };
}
