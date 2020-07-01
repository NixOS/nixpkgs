{ stdenv
, buildPythonPackage
, fetchPypi
, cython
, numpy
, python
, isPy3k
}:

buildPythonPackage rec {
  version = "2.0.2";
  pname = "fdint";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "30db139684d362652670e2cd3206b5dd7b3b93b86c3aff37f4b4fd4a3f98aead";
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  # tests not included with pypi release
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} -m fdint.tests
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/scott-maddox/fdint";
    description = "A free, open-source python package for quickly and precisely approximating Fermi-Dirac integrals";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
