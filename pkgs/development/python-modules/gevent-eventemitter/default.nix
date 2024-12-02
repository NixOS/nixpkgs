{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  coverage,
  gevent,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "gevent-eventemitter";
  version = "2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "gevent-eventemitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
  };

  build-system = [ setuptools ];
  dependencies = [ gevent ];
  nativeCheckInputs = [
    coverage
    pytestCheckHook
  ];

  meta = {
    description = "EventEmitter with gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = lib.licenses.mit; # https://github.com/rossengeorgiev/gevent-eventemitter/issues/5#issuecomment-2354040386
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
