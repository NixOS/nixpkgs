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
  version = "1.34.0";
in
buildPythonPackage {
  pname = "modelscope";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modelscope";
    repo = "modelscope";
    tag = "v${version}";
    hash = "sha256-Uq8qmU8ZmNRegaWHn1hlDDpRjWjgfecBvJklmhW36eM=";
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
