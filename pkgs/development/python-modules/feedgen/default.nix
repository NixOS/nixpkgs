{ stdenv, buildPythonPackage, fetchPypi, dateutil, lxml }:

buildPythonPackage rec {
  pname = "feedgen";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "82c9e29884e137c3e3e7959a02f142d1f7a46cd387d572e9e40150112a27604f";
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
