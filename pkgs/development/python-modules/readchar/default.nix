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
  version = "4.0.3";
  format = "setuptools";

  # Don't use wheels on PyPI
  src = fetchFromGitHub {
    owner = "magmax";
    repo = "python-${pname}";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-QMaTZRS9iOSuax706Es9WhkwU3vdcNb14dbiSt48aN0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=readchar" ""
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
