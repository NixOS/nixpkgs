{ stdenv, buildPythonPackage, fetchPypi, fetchurl, dateutil, lxml }:

buildPythonPackage rec {
  pname = "feedgen";
  version = "0.5.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a344b5e3662e9012d095a081a7f216f188dccf3a8f44ad7882960fef05e6787";
  };

  propagatedBuildInputs = [ dateutil lxml ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Python module to generate ATOM feeds, RSS feeds and Podcasts.";
    downloadPage = https://github.com/lkiesow/python-feedgen/releases;
    homepage = https://github.com/lkiesow/python-feedgen;
    license = with licenses; [ bsd2 lgpl3 ];
    maintainers = with maintainers; [ casey ];
  };
}
