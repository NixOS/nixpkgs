{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  setuptools,

  # dependencies
  coverage,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "covdefaults";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asottile";
    repo = "covdefaults";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/RqqvGL2a6sCNe5HrJ9Ty5SlingQ+dblVtGYd+z8ZKw=";
  };

  build-system = [ setuptools ];

  dependencies = [ coverage ];

  nativeCheckInputs = [ pytestCheckHook ];

  patches = [
    # Add support for coverage>=7.7.0. The patch is already in `main`
    # but not included in tag v2.3.0
    (fetchpatch2 {
      url = "https://github.com/asottile/covdefaults/commit/18fbb656ef7e90ccd2af5dbef6f100054d96c866.patch";
      hash = "sha256-/MEZEztJUKuEmFmIKTrEiZYmJ4pOFLphDDl1Q+c5TN0=";
    })
  ];

  pythonImportsCheck = [ "covdefaults" ];

  meta = {
    description = "A coverage plugin to provide sensible default settings";
    homepage = "https://github.com/asottile/covdefaults";
    changelog = "https://github.com/asottile/covdefaults/commits/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilovelinux ];
  };
})
