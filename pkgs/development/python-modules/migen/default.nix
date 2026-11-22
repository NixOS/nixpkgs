{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  setuptools,
  colorama,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "migen";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitea {
    domain = "git.m-labs.hk";
    owner = "M-Labs";
    repo = "migen";
    tag = finalAttrs.version;
    hash = "sha256-aVGzcwgcXutB9ZGiyO3v9Dmnayh+wWR9N58reOLXIf0=";
  };

  patches = [
    # Add LOAD_FAST_BORROW to opcode tracer for python 3.14.
    ./tracer-3.14.patch
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "migen" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/misc/migen";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ evanwporter ];
  };
})
