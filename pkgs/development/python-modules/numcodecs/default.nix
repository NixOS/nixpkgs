{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, cython
, numpy
, msgpack
, pytest
, python
}:

buildPythonPackage rec {
  pname = "numcodecs";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "086qwlyi01rpgyyyy8bmhh9i7hpksyz33ldci3wdwmhiblyl362y";
  };

  nativeBuildInputs = [
    setuptools_scm
    cython
  ];

  propagatedBuildInputs = [
    numpy
    msgpack
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest $out/${python.sitePackages}/numcodecs -k "not test_backwards_compatibility"
  '';

  meta = with lib;{
    homepage = https://github.com/alimanfoo/numcodecs;
    license = licenses.mit;
    description = "Buffer compression and transformation codecs for use in data storage and communication applications";
    maintainers = [ maintainers.costrouc ];
  };
}
