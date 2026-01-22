{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  filelock,
  requests,
  tqdm,
}:

let
  version = "1.33.0";
in
buildPythonPackage {
  pname = "modelscope";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${version}";
    hash = "sha256-CEaeO6oD1enGKT87anc3qSynDaN8pTC4utNoMBTvL84=";
  };

  build-system = [ setuptools ];

  dependencies = [
    filelock
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
    ];
  };
}
