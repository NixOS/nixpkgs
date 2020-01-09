{ stdenv, buildPythonPackage, fetchPypi, dateutil, lxml }:

buildPythonPackage rec {
  pname = "feedgen";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0551ixbcz2gaala4gi3i8gici3haijj7dhvjsz1a61s050276m96";
  };

  propagatedBuildInputs = [ dateutil lxml ];

  # No tests in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python module to generate ATOM feeds, RSS feeds and Podcasts.";
    downloadPage = https://github.com/lkiesow/python-feedgen/releases;
    homepage = https://github.com/lkiesow/python-feedgen;
    license = with licenses; [ bsd2 lgpl3 ];
    maintainers = with maintainers; [ casey ];
  };
}
