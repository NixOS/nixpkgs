{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  hatch-vcs,
  # test
  pytestCheckHook,
  numpy,
  scipy,
}:

buildPythonPackage rec {
  pname = "autoray";
  version = "0.8.4";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "jcmgray";
    repo = "autoray";
    tag = "v${version}";
    hash = "sha256-qpkbrmAhtubj+kmG2LotT5nV39JCoa0k8dPck3xNOrM=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  doCheck = true;

  pythonImportsCheck = [ "autoray" ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
    scipy
  ];

  meta = {
    homepage = "https://github.com/jcmgray/autoray";
    description = "Abstract your array operations";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
