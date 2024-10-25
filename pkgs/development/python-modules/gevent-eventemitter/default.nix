{
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  lib,
  setuptools,
}:
buildPythonPackage rec {
  pname = "gevent-eventemitter";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "gevent-eventemitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
  };

  build-system = [ setuptools ];

  dependencies = [ gevent ];

  pythonImportsCheck = [ "eventemitter" ];

  meta = {
    description = "EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jackwilsdon ];
  };
}
