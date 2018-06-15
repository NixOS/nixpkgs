{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, pycryptodome, pytest, cryptography
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "2.0.2";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    # 2.0.2 not tagged on GitHub
    # see https://github.com/mpdavis/python-jose/issues/86
    rev = "28cc6719eceb89129eed59c25f7bdac015665bdd";
    sha256 = "03wkq2rszy0rzy5gygsh4s7i6ls8zflgbcvxnflvmh7nis7002fp";
  };

  checkInputs = [
    pytest
    cryptography # optional dependency, but needed in tests
  ];
  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ future six ecdsa pycryptodome ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mpdavis/python-jose;
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
