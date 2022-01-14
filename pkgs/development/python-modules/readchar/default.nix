{ lib, buildPythonPackage, fetchFromGitHub, flake8, pytest, pytest-cov, pexpect }:

buildPythonPackage rec {
  pname = "readchar";
  version = "3.0.5";

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = version;
    sha256 = "01bjw3ipdzxq1ijn9354nlya625i26ri7jac1dnlj1d1gdd8m5lx";
  };

  nativeBuildInputs = [ flake8 ];
  checkInputs = [ pytest pytest-cov pexpect ];

  meta = with lib; {
    homepage = "https://github.com/magmax/python-readchar";
    description = "Python library to read characters and key strokes";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
