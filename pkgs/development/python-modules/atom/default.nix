{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  cppy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "atom";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = "atom";
    tag = finalAttrs.version;
    hash = "sha256-hktKA57ZT4HSRTtqqnznkGWBJJUPHu4mzlrRFO6FrjI=";
  };

  build-system = [ setuptools-scm ];

  buildInputs = [ cppy ];

  preCheck = ''
    rm -rf atom
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "atom.api" ];

  meta = {
    description = "Memory efficient Python objects";
    homepage = "https://github.com/nucleic/atom";
    changelog = "https://github.com/nucleic/atom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
  };
})
