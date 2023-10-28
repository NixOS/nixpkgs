{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, attrs
, numpy
, pulp
, torch
, tqdm
, transformers
}:

buildPythonPackage rec {
  pname = "flexgen";
  version = "0.1.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GYnl5CYsMWgTdbCfhWcNyjtpnHCXAcYWtMUmAJcRQAM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    attrs
    numpy
    pulp
    torch
    tqdm
    transformers
  ];

  pythonImportsCheck = [ "flexgen" ];

  meta = with lib; {
    description = "Running large language models like OPT-175B/GPT-3 on a single GPU. Focusing on high-throughput large-batch generation";
    homepage = "https://github.com/FMInference/FlexGen";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
