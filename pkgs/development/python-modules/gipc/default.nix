{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "0.6.0";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0pd9by719qh882hqs6xpby61sn1x5h98hms5p2p8yqnycrf1s0h2";
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
