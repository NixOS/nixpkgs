{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "greencell-client";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csg-sa";
    repo = "greencell-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yj2vyAWv1wPsEUZEEc2fUfTLid6xfhZvHZebkIMA778=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "greencell_client" ];

  meta = {
    description = "Library for communication with Greencell devices used by the Home Assistant integration";
    homepage = "https://github.com/csg-sa/greencell-client";
    changelog = "https://github.com/csg-sa/greencell-client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
