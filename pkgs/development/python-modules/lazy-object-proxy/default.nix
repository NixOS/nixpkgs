{ lib
, buildPythonPackage
, fetchPypi
, pytest
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "lazy-object-proxy";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5944a9b95e97de1980c65f03b79b356f30a43de48682b8bdd90aa5089f0ec1f4";
  };

  nativeBuildInputs = [ setuptools_scm ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test tests
  '';

  # Broken tests. Seem to be fixed upstream according to Travis.
  doCheck = false;

  meta = with lib; {
    description = "A fast and thorough lazy object proxy";
    homepage = "https://github.com/ionelmc/python-lazy-object-proxy";
    license = with licenses; [ bsd2 ];
  };

}
