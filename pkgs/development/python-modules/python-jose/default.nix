{ stdenv, buildPythonPackage, fetchFromGitHub
, future, six, ecdsa, pycryptodome, pytest
}:

buildPythonPackage rec {
  pname = "python-jose";
  name = "${pname}-${version}";
  version = "1.3.2";
  src = fetchFromGitHub {
    owner = "mpdavis";
    repo = "python-jose";
    rev = version;
    sha256 = "0933pbflv2pvws5m0ksz8y1fqr8m123smmrbr5k9a71nssd502sv";
  };

  buildInputs = [ pytest ];
  checkPhase = "py.test .";
  patches = [
    # to use pycryptodme instead of pycrypto
    ./pycryptodome.patch
  ];
  propagatedBuildInputs = [ future six ecdsa pycryptodome ];
  meta = with stdenv.lib; {
    homepage = "https://github.com/mpdavis/python-jose";
    description = "A JOSE implementation in Python";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [ maintainers.jhhuh ];
  };
}
