{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mypy,
  setuptools,
  wheel,
}:
buildPythonPackage (finalAttrs: {
  pname = "pytokens";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tusharsadhwani";
    repo = "pytokens";
    tag = finalAttrs.version;
    hash = "sha256-DOCOoZ3T7qh8me1vn7qYlEMiyc31d77sf1/5RsW5sUg=";
  };

  build-system = [
    mypy
    setuptools
    wheel
  ];

  doCheck = false;

  pythonImportsCheck = [ "pytokens" ];

  meta = {
    description = "Fast, spec-compliant tokenizer for modern Python syntax";
    homepage = "https://github.com/tusharsadhwani/pytokens";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
  };
})
