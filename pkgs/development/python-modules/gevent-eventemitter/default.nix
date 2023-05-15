{ lib
, buildPythonPackage
, fetchFromGitHub
, gevent
}:

buildPythonPackage rec {
  pname = "gevent-eventemitter";
  version = "2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rossengeorgiev";
    repo = "gevent-eventemitter";
    rev = "v${version}";
    hash = "sha256-aW4OsQi3N5yAMdbTd8rxbb2qYMfFJBR4WQFIXvxpiMw=";
  };

  pythonImportsCheck = [ "eventemitter" ];

  propagatedBuildInputs = [ gevent ];

  meta = with lib; {
    description = "EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
