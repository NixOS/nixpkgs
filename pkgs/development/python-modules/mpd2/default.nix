{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, twisted
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S67DWEzEPtmUjVVZB5+vwmebBrKt4nPpCbNYJlSys/U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
