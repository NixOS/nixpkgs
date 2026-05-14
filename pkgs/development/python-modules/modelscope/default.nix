{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
  packaging,
  requests,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "modelscope";
  version = "1.36.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4AmilIVmsfi+mS+iUhd4MX8n/U8gowkL0dnFpJ90iGQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
    packaging
    requests
    setuptools
    tqdm
  ];

  doCheck = false; # need network

  pythonImportsCheck = [ "modelscope" ];

  meta = {
    description = "Bring the notion of Model-as-a-Service to life";
    homepage = "https://github.com/modelscope/modelscope";
    license = lib.licenses.asl20;
    mainProgram = "modelscope";
    maintainers = with lib.maintainers; [
      kyehn
      doronbehar
      ryan4yin
    ];
  };
})
