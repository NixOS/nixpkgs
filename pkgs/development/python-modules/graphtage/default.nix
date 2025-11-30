{
  lib,
  buildPythonPackage,
  colorama,
  distutils,
  fetchFromGitHub,
  fickling,
  intervaltree,
  json5,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  scipy,
  setuptools,
  tqdm,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "graphtage";
  version = "0.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "graphtage";
    tag = "v${version}";
    hash = "sha256-Bz2T8tVdVOdXt23yPITkDNL46Y5LZPhY3SXZ5bF3CHw=";
  };

  pythonRelaxDeps = [ "json5" ];

  build-system = [
    distutils
    setuptools
  ];

  dependencies = [
    colorama
    fickling
    intervaltree
    json5
    pyyaml
    scipy
    tqdm
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "graphtage" ];

  meta = with lib; {
    description = "Utility to diff tree-like files such as JSON and XML";
    homepage = "https://github.com/trailofbits/graphtage";
    changelog = "https://github.com/trailofbits/graphtage/releases/tag/v${version}";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
    mainProgram = "graphtage";
  };
}
