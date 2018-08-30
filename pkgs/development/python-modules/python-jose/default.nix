{ stdenv, buildPythonPackage, fetchFromGitHub
, six, ecdsa, rsa, future, pytest, cryptography, pycryptodome
}:

buildPythonPackage rec {
  pname = "python-jose";
  version = "3.0.0";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "1dq8v87abqxv07wi403ywjk9jg1da125fviycqzki48cjxx0dhwj";
  };

  checkInputs = [
    pytest
    # optional dependencies, but needed in tests
    cryptography pycryptodome
  ];
  checkPhase = ''
    py.test
  '';

  propagatedBuildInputs = [ six ecdsa rsa future ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mpdavis/python-jose;
    description = "A JOSE implementation in Python";
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
