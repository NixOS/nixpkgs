{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  subprocess4,
}:

buildPythonPackage (finalAttrs: {
  pname = "coq-tools";
  version = "0.0.44";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JasonGross";
    repo = "coq-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2WMxJkLGfMtXu4ZpIuS1wIXMvgJbCMy2eY8qz5+v9LI=";
  };

  build-system = [ setuptools ];

  dependencies = [ subprocess4 ];

  pythonImportsCheck = [ "coq_tools" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Tools for working with Coq proof assistant";
    homepage = "https://pypi.org/project/coq-tools/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
