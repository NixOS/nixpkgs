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
  version = "1.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = "aggdraw";
    rev = "v${version}";
    hash = "sha256-rBasRGdlM6/NsUd8+KsgHoZMsWhAhneSWjTeZ/QQZZ8=";
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

  meta = {
    description = "High quality drawing interface for PIL";
    homepage = "https://github.com/pytroll/aggdraw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
