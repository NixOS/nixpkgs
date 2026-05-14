{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  python,
  setuptools,
}:

let
  version = "2026.2.19";
in
buildPythonPackage {
  pname = "regex";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mrabarnett";
    repo = "mrab-regex";
    tag = version;
    hash = "sha256-/Uqq/Z1fwn6TKQ6UfYfOUJ6t7njSZyxTAb1lEXPg5f8=";
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
}
