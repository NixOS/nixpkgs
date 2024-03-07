{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, twisted
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8zws2w1rqnSjZyTzjBxKCZp84sjsSiu3GSFQpYVd9HY=";
  };

  passthru.optional-dependencies = {
    twisted = [
      twisted
    ];
  };

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ passthru.optional-dependencies.twisted;

  meta = with lib; {
    changelog = "https://github.com/Mic92/python-mpd2/blob/v${version}/doc/changes.rst";
    description = "A Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ mic92 hexa ];
  };

}
