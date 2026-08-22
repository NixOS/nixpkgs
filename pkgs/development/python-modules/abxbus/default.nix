{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  pydantic,
  typing-extensions,
  uuid7,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "abxbus";
  version = "2.5.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-8xfdX8jcs3qT35Ld1JDSu1yE7U+7FR3rcyUxHAUKehA=";
  };

  postPatch = ''
    # Relax build-system and runtime version pins that are tighter than needed
    substituteInPlace pyproject.toml \
      --replace-fail '"uv_build>=0.11.11,<0.12.0"' '"uv_build"' \
      --replace-fail '"pydantic>=2.13.4"' '"pydantic>=2.0.0"'
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    pydantic
    typing-extensions
    uuid7
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests require optional bridge integrations (redis, nats, asyncpg) not packaged here
  doCheck = false;

  pythonImportsCheck = [ "abxbus" ];

  meta = {
    changelog = "https://github.com/ArchiveBox/abxbus/releases";
    description = "Pydantic-powered event bus for the ArchiveBox plugin ecosystem";
    homepage = "https://github.com/ArchiveBox/abxbus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
