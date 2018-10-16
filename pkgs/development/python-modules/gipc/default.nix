{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "0.5.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "08c35xzv7nr12d9xwlywlbyzzz2igy0yy6y52q2nrkmh5d4slbpc";
  };

  propagatedBuildInputs = [ gevent ];

  meta = with stdenv.lib; {
    description = "gevent-cooperative child processes and IPC";
    longDescription = ''
      Usage of Python's multiprocessing package in a gevent-powered
      application may raise problems and most likely breaks the application
      in various subtle ways. gipc (pronunciation "gipsy") is developed with
      the motivation to solve many of these issues transparently. With gipc,
      multiprocessing. Process-based child processes can safely be created
      anywhere within your gevent-powered application.
    '';
    homepage = http://gehrcke.de/gipc;
    license = licenses.mit;
  };

}
