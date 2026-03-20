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
  version = "1.35.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p8Pv58IpP165z4CHq+CO6160LyHd3BS3Y3I2JBGp4KE=";
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
