{ lib
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6045b22dfbd8aec5542fe15d71684e46df0a4de852ccae6a02c9db3a24076e01";
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
