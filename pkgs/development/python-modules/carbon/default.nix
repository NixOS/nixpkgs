{ lib, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95918c4b14e1c525d9499554d5e03b349f87e0c2bc17ec5c64d18679a30b69f1";
  };

  # Carbon-s default installation is /opt/graphite. This env variable ensures
  # carbon is installed as a regular python module.
  GRAPHITE_NO_PREFIX="True";

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with lib; {
    homepage = "http://graphiteapp.org/";
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
