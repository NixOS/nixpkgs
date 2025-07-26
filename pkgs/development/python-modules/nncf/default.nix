{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  jsonschema,
  jstyleson,
  natsort,
  networkx,
  ninja,
  numpy,
  openvino-telemetry,
  packaging,
  pandas,
  psutil,
  pydot,
  pymoo,
  rich,
  safetensors,
  scikit-learn,
  scipy,
  tabulate,
}:

buildPythonPackage rec {
  pname = "nncf";
  version = "2.16.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FWSpuQk0bXhiX6ZF05e4LARsmpml++2TrlbG3aOeGuE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    jsonschema
    jstyleson
    natsort
    networkx
    ninja
    numpy
    openvino-telemetry
    packaging
    pandas
    psutil
    pydot
    pymoo
    rich
    safetensors
    scikit-learn
    scipy
    tabulate
  ];
  # without extra plots
  pythonRelaxDeps = [ "ninja" ];
  pythonImportsCheck = [
    "nncf"
  ];
  postPatch = ''
    echo 'version = "${version}"' > custom_version.py
  '';
  meta = {
    description = "Neural Networks Compression Framework";
    homepage = "https://pypi.org/project/nncf/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
