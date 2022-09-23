{ lib
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P8d2GIxFAAHeXjXgIxKGwahiH1TW/9fE+V0f9Ra54wo=";
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
  };

}
