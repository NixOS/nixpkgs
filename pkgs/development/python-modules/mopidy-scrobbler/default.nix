{
  lib,
  buildPythonPackage,
  fetchPypi,
  mopidy,
  setuptools,
  pylast,
}:

buildPythonPackage rec {
  pname = "mopidy-scrobbler";
  version = "2.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Mopidy-Scrobbler";
    sha256 = "11vxgax4xgkggnq4fr1rh2rcvzspkkimck5p3h4phdj3qpnj0680";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mopidy
    pylast
  ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_scrobbler" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-scrobbler";
    description = "Mopidy extension for scrobbling played tracks to Last.fm";
    license = licenses.asl20;
    maintainers = with maintainers; [ jakeisnt ];
  };
}
