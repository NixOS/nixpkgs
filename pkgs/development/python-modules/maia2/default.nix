{
  lib,
  buildPythonPackage,
  fetchPypi,
  chess,
  einops,
  flit-core,
  gdown,
  numpy,
  pandas,
  pyyaml,
  pyzstd,
  requests,
  torch,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "maia2";
  version = "0.9";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-hiU5/xgR0JpvDzq1NEaG8VidSZL6FXcn0xFW26IlHNE=";
  };

  build-system = [ flit-core ];

  dependencies = [
    chess
    einops
    gdown
    numpy
    pandas
    pyyaml
    pyzstd
    requests
    torch
    tqdm
  ];

  pythonImportsCheck = [ "maia2" ];

  meta = {
    description = "Unified model for human-AI alignment in chess";
    homepage = "https://github.com/CSSLab/maia2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malix ];
  };
})
