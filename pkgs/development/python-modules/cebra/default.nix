{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchPypi,
  joblib,
  numpy,
  matplotlib,
  pythonOlder,
  requests,
  setuptools,
  scipy,
  scikit-learn,
  torch,
  tqdm,
}:
let
  version = "0.5.0";

  # building literate_dataclasses which is a core dependency for the project
  literate_dataclasses = buildPythonPackage {
    pname = "literate-dataclasses";
    version = "0.0.6";
    src = fetchPypi {
      pname = "literate_dataclasses";
      version = "0.0.6";
      hash = "sha256-usA7MYqhlQTcabfOOxoDwXMEuPKpFWM37IrCwCp4By0=";
    };

    pyproject = true;

    pythonImportsCheck = [
      "literate_dataclasses"
    ];

    buildInputs = [
      setuptools
    ];
  };
in
buildPythonPackage {
  inherit version;
  pname = "cebra";
  src = fetchFromGitHub {
    owner = "AdaptiveMotorControlLab";
    repo = "CEBRA";
    tag = "v${version}";
    hash = "sha256-sZSpRjeQSCV7jmWsZ28nd8KCcai3BVXkrPCwh0qaW4A=";
  };
  pyproject = true;

  disabled = pythonOlder "3.9";

  dependencies = [
    literate_dataclasses
    joblib
    numpy
    scipy
    scikit-learn
    torch
    tqdm
    matplotlib
    requests
  ];

  buildInputs = [
    setuptools
  ];

  doCheck = true;
  # checking the main imports work
  pythonImportsCheckHook = [
    "cebra"
    "cebra.CEBRA"
    "literate_dataclasses"
  ];

  #copying the needed outputs of literate_dataclasses into cebra's derivation
  postInstall = ''
    mkdir -p $out/lib/python3.12/site-packages/literate_dataclasses
    cp -r ${literate_dataclasses}/lib/python3.12/site-packages/* $out/lib/python3.12/site-packages/literate_dataclasses/
  '';

  meta = {
    changelog = "https://github.com/AdaptiveMotorControlLab/CEBRA/releases/tag/v${version}";
    description = "Learnable latent embeddings for joint behavioral and neural analysis";
    homepage = "https://cebra.ai/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.FKouhai ];
  };
}
