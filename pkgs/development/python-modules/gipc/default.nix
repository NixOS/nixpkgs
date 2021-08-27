{ lib
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gipc";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a25ccfd2f8c94b24d2113fa50a0de5c7a44499ca9f2ab7c91c3bec0ed96ddeb1";
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
