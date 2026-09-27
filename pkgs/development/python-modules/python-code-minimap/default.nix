{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-code-minimap";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joouha";
    repo = "python-code-minimap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zp0F5vJPZAp8lBFBOLWYMuAzlerXDa0vM9P3oBtBjGo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.9.0,<0.10.0" \
        "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonImportsCheck = [ "code_minimap" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Pure Python code minimap render";
    homepage = "https://github.com/joouha/python-code-minimap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
