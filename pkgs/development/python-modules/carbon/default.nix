{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, twisted, whisper, txamqp, cachetools, urllib3
}:

buildPythonPackage rec {
  pname = "carbon";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nyg9xmqbnyr35c1x0fcic2pwr9sv273ansbnzyji9ly79ar10x8";
  };

  propagatedBuildInputs = [ twisted whisper txamqp cachetools urllib3 ];

  meta = with stdenv.lib; {
    homepage = http://graphite.wikidot.com/;
    description = "Backend data caching and persistence daemon for Graphite";
    maintainers = with maintainers; [ rickynils offline basvandijk ];
    license = licenses.asl20;
  };
}
