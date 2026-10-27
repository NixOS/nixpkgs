{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-ipware";
  version = "4.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "python-ipware";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PYWOihNMHaYAnDeLQ2T5RnS5N9T1E5skv33EANgVdX8=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "python_ipware" ];

  meta = {
    description = "Python package for server applications to retrieve client's IP address";
    homepage = "https://github.com/un33k/python-ipware";
    changelog = "https://github.com/un33k/python-ipware/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ e1mo ];
  };
})
