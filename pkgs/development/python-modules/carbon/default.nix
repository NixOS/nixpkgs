{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.6";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ecda1469e497e3fed346b23ac94fd576e1bd9962677ab88975f4f598186e851";
  };

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ offline basvandijk ];
    license = licenses.asl20;
  };
}
