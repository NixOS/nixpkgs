{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  requests,
  pydantic,
  pydantic-xml,
  pydantic-settings,
  certifi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyregrws";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jsenecal";
    repo = "pyregrws";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GAiFT8/aGAjClB2qzWoOiZKGRRkkjNAkQivAjw4QwBk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.9.0,<0.10.0' 'uv_build>=0.9.0'
  '';

  build-system = [ uv-build ];

  dependencies = [
    requests
    pydantic
    pydantic-xml
    pydantic-settings
    certifi
  ];

  pythonImportsCheck = [ "regrws" ];

  meta = {
    description = "Python library to retrieve and modify records within ARIN's database through their Reg-RWS service";
    homepage = "https://github.com/jsenecal/pyregrws";
    changelog = "https://github.com/jsenecal/pyregrws/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
