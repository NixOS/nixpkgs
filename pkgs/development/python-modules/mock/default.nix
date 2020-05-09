{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, funcsigs
, six
, pbr
, python
}:

buildPythonPackage rec {
  pname = "mock";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd33eb70232b6118298d516bbcecd26704689c386594f0f3c4f13867b2c56f72";
  };

  propagatedBuildInputs = [ six pbr ] ++ lib.optionals isPy27 [ funcsigs ];

  # On PyPy for Python 2.7 in particular, Mock's tests have a known failure.
  # Mock upstream has a decoration to disable the failing test and make
  # everything pass, but it is not yet released. The commit:
  # https://github.com/testing-cabal/mock/commit/73bfd51b7185#diff-354f30a63fb0907d4ad57269548329e3L12
  doCheck = !(python.isPyPy && python.isPy27);

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Mock objects for Python";
    homepage = "http://python-mock.sourceforge.net/";
    license = licenses.bsd2;
  };

}
