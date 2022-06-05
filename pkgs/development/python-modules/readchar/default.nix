{ lib
, buildPythonPackage
, fetchFromGitHub

# native
, flake8

# tests
, pytestCheckHook
, pexpect
}:

buildPythonPackage rec {
  pname = "readchar";
  version = "3.0.5";
  format = "setuptools";

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256:01bjw3ipdzxq1ijn9354nlya625i26ri7jac1dnlj1d1gdd8m5lx";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov readchar" ""
  '';

  nativeBuildInputs = [
    flake8
  ];

  checkInputs = [
    pytestCheckHook
    pexpect
  ];

  meta = with lib; {
    homepage = "https://github.com/magmax/python-readchar";
    description = "Python library to read characters and key strokes";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
  };
}
