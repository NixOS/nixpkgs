{ stdenv, buildPythonPackage, fetchFromGitHub, flake8, pytest, pytestcov, pexpect }:

buildPythonPackage rec {
  pname = "readchar";
  version = "2.0.0";

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = version;
    sha256 = "0j1vj4f2j8x5f40rs6h8qplklcxcdbvkkvjpkpmr1xagw05i12bm";
  };

  nativeBuildInputs = [ flake8 ];
  checkInputs = [ pytest pytestcov pexpect ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/magmax/python-readchar";
    description = "Python library to read characters and key strokes";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
