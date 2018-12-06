{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.4";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b70e34ac0f0bd32a03ee14eaf1ed2c857e208984fc9761f59a95c21c5264513";
  };

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
