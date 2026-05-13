{
  lib,
  badges,
  buildPythonPackage,
  capstone,
  fetchFromGitHub,
  keystone-engine,
  lief,
  pyelftools,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hatasm";
  version = "1.0.0-unstable-2026-01-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "EntySec";
    repo = "HatAsm";
    # https://github.com/EntySec/HatAsm/issues/2
    rev = "c8ec79e533a2dd489de86cefc168fce576f21f1a";
    hash = "sha256-PqQRe01cZMEOBjkbBqnb9jXcdSQ3LSSJtwwaP0ITgKg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    badges
    capstone
    keystone-engine
    lief
    pyelftools
  ];

  pythonImportsCheck = [ "hatasm" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Assembler and disassembler that provides support for all common architectures";
    homepage = "https://github.com/EntySec/HatAsm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
