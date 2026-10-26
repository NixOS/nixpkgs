{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "myuplink";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pajzo";
    repo = "myuplink";
    tag = finalAttrs.version;
    hash = "sha256-r06aap8FiRslRRgKKSH7vNzpoVn6rX8ZR0oQ0D68xDo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "%%VERSION_NO%%" "${finalAttrs.version}"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "myuplink" ];

  meta = {
    description = "Module to interact with the myUplink API";
    homepage = "https://github.com/pajzo/myuplink";
    changelog = "https://github.com/pajzo/myuplink/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
