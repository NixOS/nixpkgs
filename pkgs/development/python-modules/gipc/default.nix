{ lib
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9a9d557e65e17bab8d7ff727ee3f1935e25bd52b01e63c23c7b3b52415728a5";
  };

  propagatedBuildInputs = [ gevent ];

  meta = with lib; {
    description = "gevent-cooperative child processes and IPC";
    longDescription = ''
      Usage of Python's multiprocessing package in a gevent-powered
      application may raise problems and most likely breaks the application
      in various subtle ways. gipc (pronunciation "gipsy") is developed with
      the motivation to solve many of these issues transparently. With gipc,
      multiprocessing. Process-based child processes can safely be created
      anywhere within your gevent-powered application.
    '';
    homepage = "http://gehrcke.de/gipc";
    license = licenses.mit;
    # gipc only has support for older versions of gevent
    broken = versionOlder "1.6" gevent.version;
  };

}
