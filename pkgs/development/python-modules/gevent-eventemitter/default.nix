{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
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
    rev = "v${version}";
    hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    gevent
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = ["eventemitter"];

  meta = with lib; {
    description = "EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
