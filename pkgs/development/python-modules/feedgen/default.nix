{ stdenv, buildPythonPackage, fetchPypi, fetchurl, dateutil, lxml }:

buildPythonPackage rec {
  pname = "feedgen";
  version = "0.6.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e5a1f2a8aaed06dae325e6024aa7083e90655c6cbddeb3671249b3895c135762";
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
