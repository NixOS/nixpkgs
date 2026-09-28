{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyscss";
  version = "1.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    repo = "pyScss";
    owner = "Kronuz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0y4z+/JE6rZWHAvps/taDZvutyVhxxs2gMujV5rNu4=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Test suite is broken.
  # See https://github.com/Kronuz/pyScss/issues/415
  doCheck = false;

  meta = {
    description = "Scss compiler for Python";
    homepage = "https://pyscss.readthedocs.org/en/latest/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
