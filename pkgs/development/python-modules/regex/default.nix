{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  setuptools,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "regex";
  version = "2026.7.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrabarnett";
    repo = "mrab-regex";
    tag = finalAttrs.version;
    hash = "sha256-x9XjtIUjm1eV0GS0216ZimHx6DNxtxZV5pQ6dbkEfTc=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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
