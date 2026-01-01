{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  packaging,
  setuptools,
  pkgconfig,
  freetype,
  pytest,
  python,
  pillow,
  numpy,
}:

buildPythonPackage rec {
  pname = "aggdraw";
<<<<<<< HEAD
  version = "1.4.1";
  pyproject = true;
=======
  version = "1.3.19";
  format = "pyproject";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = "aggdraw";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-rBasRGdlM6/NsUd8+KsgHoZMsWhAhneSWjTeZ/QQZZ8=";
  };

  build-system = [
=======
    rev = "v${version}";
    hash = "sha256-J9+mxlUxOoRBFdz+p8me2T93jaov5rNvKbAZ2YX/VhA=";
  };

  nativeBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    packaging
    setuptools
    pkgconfig
  ];

  buildInputs = [ freetype ];

  nativeCheckInputs = [
    numpy
    pillow
    pytest
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} selftest.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "aggdraw" ];

<<<<<<< HEAD
  meta = {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    changelog = "https://github.com/pytroll/aggdraw/blob/${src.tag}CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
=======
  meta = with lib; {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
