{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pycryptodome,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymitsubishi";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "pymitsubishi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e2BbeJQH1SSge/SoU5ylF1/wHz2BBcBRqlpvX8WFJhs=";
  };

  postPatch = ''
    # make sure pyproject.toml specifies the correct version
    grep -qF 'version = "${finalAttrs.version}"' pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycryptodome
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymitsubishi" ];

  meta = {
    description = "Library for controlling and monitoring Mitsubishi MAC-577IF-2E air conditioners";
    homepage = "https://github.com/pymitsubishi/pymitsubishi";
    changelog = "https://github.com/pymitsubishi/pymitsubishi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uvnikita ];
  };
})
