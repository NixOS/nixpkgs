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
  version = "1.3.18";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dM6yLR6xsZerpqY+BMxIjrJ3fQty9CFUWhxl2zkTgRA=";
  };

  nativeBuildInputs = [
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

  meta = with lib; {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
