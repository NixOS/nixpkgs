{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.3";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s7327p30w4l9ak4gc7m5ga521233179n2lr3j0ggfbmfhd6blky";
  };

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
