{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, pythonRelaxDepsHook
, dill
, lightning-utilities
, numpy
, torch
, threadpoolctl
, tqdm
}:

buildPythonPackage rec {
  pname = "rising";
  version = "0.3.0";
  disabled = pythonOlder "TODO";

  src = fetchFromGitHub {
    owner = "PhoenixDL";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sBzVTst5Tp2oZZ+Xsg3M7uAMbucL6idlpYwHvib3EaY=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "lightning-utilities" ];

  propagatedBuildInputs = [
    lightning-utilities numpy torch threadpoolctl tqdm
  ];
  nativeCheckInputs = [ dill pytestCheckHook ];

  pythonImportsCheck = [
    "rising"
    "rising.loading"
    "rising.ops"
    "rising.random"
    "rising.transforms"
    "rising.transforms.functional"
    "rising.utils"
  ];

  meta = {
    description = "High-performance data loading and augmentation library in PyTorch";
    homepage = "https://rising.rtfd.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
