{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  gevent,

  pytestCheckHook,

  setuptools,
}:
buildPythonPackage rec {
  pname = "gevent-eventemitter";
  version = "2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "gevent-eventemitter";
    tag = "v${version}";
    hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    gevent
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ weirdrock ];
  };
}
