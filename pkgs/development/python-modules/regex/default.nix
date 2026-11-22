{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "regex";
  version = "2026.9.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrabarnett";
    repo = "mrab-regex";
    tag = finalAttrs.version;
    hash = "sha256-9WiynNc25LhHzooLEU4AubVFc6fXAJnBjqPIvfk/l44=";
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
    changelog = "https://github.com/mrabarnett/mrab-regex/blob/${finalAttrs.src.tag}/changelog.txt";
    description = "Alternative regular expression module, to replace re";
    homepage = "https://github.com/mrabarnett/mrab-regex";
    license = [
      lib.licenses.asl20
      lib.licenses.cnri-python
    ];
    maintainers = [ lib.maintainers.dwoffinden ];
  };
})
