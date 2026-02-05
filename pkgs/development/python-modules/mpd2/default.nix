{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  twisted,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-mpd2";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S67DWEzEPtmUjVVZB5+vwmebBrKt4nPpCbNYJlSys/U=";
  };

  nativeBuildInputs = [ setuptools ];

  optional-dependencies = {
    twisted = [ twisted ];
  };

  nativeCheckInputs = [ unittestCheckHook ] ++ optional-dependencies.twisted;

  meta = {
    changelog = "https://github.com/Mic92/python-mpd2/blob/v${version}/doc/changes.rst";
    description = "Python client module for the Music Player Daemon";
    homepage = "https://github.com/Mic92/python-mpd2";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      mic92
      hexa
    ];
  };
}
