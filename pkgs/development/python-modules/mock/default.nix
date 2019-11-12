{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, funcsigs
, six
, pbr
, python
}:

buildPythonPackage rec {
  pname = "mock";
  version = "3.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83657d894c90d5681d62155c82bda9c1187827525880eda8ff5df4ec813437c3";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ funcsigs six pbr ];

  # On PyPy for Python 2.7 in particular, Mock's tests have a known failure.
  # Mock upstream has a decoration to disable the failing test and make
  # everything pass, but it is not yet released. The commit:
  # https://github.com/testing-cabal/mock/commit/73bfd51b7185#diff-354f30a63fb0907d4ad57269548329e3L12
  doCheck = !(python.isPyPy && python.isPy27);

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "Mock objects for Python";
    homepage = http://python-mock.sourceforge.net/;
    license = stdenv.lib.licenses.bsd2;
  };

}
