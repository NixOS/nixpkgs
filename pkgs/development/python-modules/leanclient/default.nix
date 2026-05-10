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
}:

buildPythonPackage (finalAttrs: {
  pname = "leanclient";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "leanclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v6Z2uC3cnGRp+0xuX79hqPz95xxZ4qYNx5sHBrykI/M=";
  };

  build-system = [ hatchling ];

  dependencies = [
    orjson
    psutil
    tqdm
  ];

  # Tests require a real Lean toolchain
  doCheck = false;

  pythonImportsCheck = [ "leanclient" ];

  meta = {
    description = "Python client for the Lean theorem prover LSP";
    homepage = "https://github.com/oOo0oOo/leanclient";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
