{
  lib,
  buildPythonPackage,
  fetchPypi,
  emoji,
  pydbus,
  pygobject3,
  unidecode,
  setuptools,
}:
buildPythonPackage rec {
  pname = "mpris-server";
  version = "0.4.2";
  pyproject = true;

  src = fetchPypi {
    pname = "mpris_server";
    inherit version;
    hash = "sha256-p3nM80fOMtRmeKvOXuX40Fu9xH8gPgYyneXbUS678fE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    emoji
    pydbus
    pygobject3
    unidecode
  ];

  pythonRelaxDeps = [ "emoji" ];

  pythonImportsCheck = [ "mpris_server" ];

  # upstream has no tests
  doCheck = false;

  # update doesn't support python311 and monophony, the only consumer requires
  # 0.4.2
  passthru.skipBulkUpdate = true;

  meta = with lib; {
    description = "Publish a MediaPlayer2 MPRIS device to D-Bus";
    homepage = "https://pypi.org/project/mpris-server/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ quadradical ];
  };
}
