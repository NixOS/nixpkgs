{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  orjson,
  psutil,
  tqdm,
  watchfiles,
}:

buildPythonPackage (finalAttrs: {
  pname = "leanclient";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "leanclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CFMOMQ0Ar5+zwTOAm8XG15gsytdrKto8RSA5H0Ms7u0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    orjson
    psutil
    tqdm
    watchfiles
  ];

  # Tests require a real Lean toolchain
  doCheck = false;

  pythonImportsCheck = [ "leanclient" ];

  meta = {
    description = "Python client for the Lean theorem prover LSP";
    homepage = "https://github.com/oOo0oOo/leanclient";
    changelog = "https://github.com/oOo0oOo/leanclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
