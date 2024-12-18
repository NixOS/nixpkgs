{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  lxml,
}:

buildPythonPackage rec {
  pname = "feedgen";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2b1Rw7XpVqKlKZjDcIxNLHKfL8wxEYjh5dO5cmOTVGo=";
  };

  propagatedBuildInputs = [
    python-dateutil
    lxml
  ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Python module to generate ATOM feeds, RSS feeds and Podcasts";
    downloadPage = "https://github.com/lkiesow/python-feedgen/releases";
    homepage = "https://github.com/lkiesow/python-feedgen";
    license = with licenses; [
      bsd2
      lgpl3
    ];
    maintainers = with maintainers; [ casey ];
  };
}
