{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "infrared-protocols";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "infrared-protocols";
    tag = finalAttrs.version;
    hash = "sha256-0WcpnZDUX+SMMd3d5V3V9BRqZpEa/bs3LwgoSrlC06w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=78.1.1,<83.0" setuptools
  '';

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "infrared_protocols" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/infrared-protocols/releases/tag/${finalAttrs.src.tag}";
    description = "Library to decode and encode infrared signals";
    homepage = "https://github.com/home-assistant-libs/infrared-protocols";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
