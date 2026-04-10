{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "regex";
  version = "2026.8.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrabarnett";
    repo = "mrab-regex";
    tag = finalAttrs.version;
    hash = "sha256-TOaJBk9W/ZEA+l2i0kzrr6RxlkdFzTIxj+Bu25JBNws=";
  };

  build-system = [ setuptools ];

  preCheck = ''
    rm regex/__init__.py
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m unittest ./regex/tests/test_regex.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "regex" ];

  meta = {
    description = "Alternative regular expression module, to replace re";
    homepage = "https://github.com/mrabarnett/mrab-regex";
    license = [
      lib.licenses.asl20
      lib.licenses.cnri-python
    ];
    maintainers = [ lib.maintainers.dwoffinden ];
  };
})
