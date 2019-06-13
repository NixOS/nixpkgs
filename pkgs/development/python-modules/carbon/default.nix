{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.5";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a88390553a9ea628fdb74b5b358ed83a657e058bcc811e5819d9db856b4fcf5b";
  };

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
