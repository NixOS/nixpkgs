{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  deprecated,
  hopcroftkarp,
  joblib,
  matplotlib,
  numpy,
  scikit-learn,
  scipy,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "cusfpredict";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "darksidelemm";
    repo = "cusf_predictor_wrapper";
    rev = "f4352834a037e3e2bf01a3fd7d5a25aa482e27c6";
    hash = "sha256-C8/5x8tim6s0hWgCC7LpN1hesdVME5kpQFqDTEyXHtg=";
  };

  doCheck = false; # No tests available

  pythonImportsCheck = [ "cusfpredict" ];

  meta = {
    description = "CUSF standalone predictor - Python wrapper";
    homepage = "https://github.com/darksidelemm/cusf_predictor_wrapper";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
