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

buildPythonPackage (finalAttrs: {
  pname = "aggdraw";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytroll";
    repo = "aggdraw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rBasRGdlM6/NsUd8+KsgHoZMsWhAhneSWjTeZ/QQZZ8=";
  };

  build-system = [
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
    changelog = "https://github.com/pytroll/aggdraw/blob/${finalAttrs.src.tag}CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
