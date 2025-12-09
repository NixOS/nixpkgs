{
  lib,
  buildPythonPackage,
  fetchPypi,
  emoji,
  pydbus,
  pygobject3,
  unidecode,
  setuptools,
  strenum,
}:
buildPythonPackage rec {
  pname = "mpris-server";
  version = "0.9.6";
  pyproject = true;

  src = fetchPypi {
    pname = "mpris_server";
    inherit version;
    hash = "sha256-T0ZeDQiYIAhKR8aw3iv3rtwzc+R0PTQuIh6+Hi4rIHQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    emoji
    pydbus
    pygobject3
    strenum
    unidecode
  ];

  pythonImportsCheck = [ "mpris_server" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Publish a MediaPlayer2 MPRIS device to D-Bus";
    homepage = "https://pypi.org/project/mpris-server/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ quadradical ];
  };
}
