{ stdenv
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zg5bm30lqqd8x0jqbvr4yi8i4rzzk2hdnh280qnj2bwm5nqpghi";
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
