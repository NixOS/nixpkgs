{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  requests,
  six,
  tqdm,
}:

buildPythonPackage rec {
  pname = "download";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iEqIVHWzzb7Aqid+QWQ5lcM5Sh4GSggW9T//rko4ITA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
    six
    tqdm
  ];

  pythonImportsCheck = [
    "download"
  ];

  meta = {
    description = "Quick module to help downloading files using python";
    homepage = "https://github.com/choldgraf/download";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jolars ];
  };
}
