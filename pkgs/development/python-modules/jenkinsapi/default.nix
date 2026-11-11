{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docker,
  hatchling,
  mock,
  pyprojectVersionPatchHook,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pytz,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "jenkinsapi";
  version = "0.3.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycontribs";
    repo = "jenkinsapi";
    tag = finalAttrs.version;
    hash = "sha256-NtILbbXu4dtYda28WaFiGkICf0bOmVMKOOnnrHptxsg=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    pytz
    requests
  ];

  nativeCheckInputs = [
    docker
    mock
    pytest-mock
    pytest-xdist
    pytestCheckHook
  ];

  # don't run tests that try to spin up jenkins
  disabledTests = [ "systests" ];

  pythonImportsCheck = [ "jenkinsapi" ];

  meta = {
    description = "Python API for accessing resources on a Jenkins continuous-integration server";
    homepage = "https://github.com/pycontribs/jenkinsapi";
    changelog = "https://github.com/pycontribs/jenkinsapi/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      de11n
      despsyched
      drets
    ];
    license = lib.licenses.mit;
  };
})
